import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/api_service.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int leftScore = 0;
  int rightScore = 0;
  int leftStreak = 0;
  int rightStreak = 0;
  int totalPoints = 0;
  bool speechEnabled = false;
  bool touchMode = true;
  String leftPlayerName = 'Left';
  String rightPlayerName = 'Right';

  final FlutterTts flutterTts = FlutterTts();
  final ScreenshotController screenshotController = ScreenshotController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speakScore() async {
    if (speechEnabled) {
      await flutterTts.speak('$leftScore $rightScore');
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = prefs.getInt('totalPoints') ?? 0;
      speechEnabled = prefs.getBool('speechEnabled') ?? false;
      leftPlayerName = prefs.getString('leftPlayerName') ?? 'Left';
      rightPlayerName = prefs.getString('rightPlayerName') ?? 'Right';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', totalPoints);
    await prefs.setBool('speechEnabled', speechEnabled);
    await prefs.setString('leftPlayerName', leftPlayerName);
    await prefs.setString('rightPlayerName', rightPlayerName);
  }

  void _incrementLeft() {
    setState(() {
      leftScore++;
      totalPoints++;
      leftStreak++;
      rightStreak = 0;
    });
    _speakScore();
    _savePreferences();
  }

  void _incrementRight() {
    setState(() {
      rightScore++;
      totalPoints++;
      rightStreak++;
      leftStreak = 0;
    });
    _speakScore();
    _savePreferences();
  }

  void _decrementLeft() {
    if (leftScore > 0) {
      setState(() {
        leftScore--;
        totalPoints = totalPoints > 0 ? totalPoints - 1 : 0;
        leftStreak = 0;
      });
      _speakScore();
      _savePreferences();
    }
  }

  void _decrementRight() {
    if (rightScore > 0) {
      setState(() {
        rightScore--;
        totalPoints = totalPoints > 0 ? totalPoints - 1 : 0;
        rightStreak = 0;
      });
      _speakScore();
      _savePreferences();
    }
  }

  void _resetGame() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Game'),
        content: const Text('Do you want to save this game to history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _showSaveDialog();
    } else if (confirm == false) {
      _performReset();
    }
  }

  Future<void> _showSaveDialog() async {
    final leftController = TextEditingController(text: leftPlayerName);
    final rightController = TextEditingController(text: rightPlayerName);
    final remarkController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Game'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: leftController,
                decoration: const InputDecoration(
                  labelText: 'Left Player Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rightController,
                decoration: const InputDecoration(
                  labelText: 'Right Player Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: remarkController,
                decoration: const InputDecoration(
                  labelText: 'Remark (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final now = DateTime.now();
              final date = DateFormat('yyyy-MM-dd').format(now);
              final time = DateFormat('HH:mm:ss').format(now);
              final score = '$leftScore-$rightScore';

              final newLeftName = leftController.text.isNotEmpty
                  ? leftController.text
                  : leftPlayerName;
              final newRightName = rightController.text.isNotEmpty
                  ? rightController.text
                  : rightPlayerName;

              await ApiService.insertHistory(
                userId: 'user123', // You can implement proper user management
                date: date,
                time: time,
                score: score,
                playerLeft: newLeftName,
                playerRight: newRightName,
                remark: remarkController.text,
              );

              if (!mounted) return;
              
              setState(() {
                leftPlayerName = newLeftName;
                rightPlayerName = newRightName;
              });
              await _savePreferences();

              if (!mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Game saved to history!')),
              );
              _performReset();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _performReset() {
    setState(() {
      leftScore = 0;
      rightScore = 0;
      leftStreak = 0;
      rightStreak = 0;
    });
  }

  Future<void> _shareScreenshot() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/badminton_score.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Badminton Score: $leftPlayerName $leftScore - $rightScore $rightPlayerName',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing screenshot: $e')),
        );
      }
    }
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Left arrow or 'A' key for left increment
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.keyA) {
        _incrementLeft();
      }
      // Right arrow or 'D' key for right increment
      else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        _incrementRight();
      }
      // 'Z' key for left decrement
      else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
        _decrementLeft();
      }
      // 'C' key for right decrement
      else if (event.logicalKey == LogicalKeyboardKey.keyC) {
        _decrementRight();
      }
      // 'R' key for reset
      else if (event.logicalKey == LogicalKeyboardKey.keyR) {
        _resetGame();
      }
      // 'S' key for speech toggle
      else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        setState(() {
          speechEnabled = !speechEnabled;
        });
        _savePreferences();
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Widget _buildStreakIndicator(int streak) {
    if (streak == 0) {
      return const SizedBox.shrink();
    } else if (streak >= 1 && streak <= 3) {
      // Show individual fire emojis for 1-3
      return Text(
        '🔥' * streak,
        style: const TextStyle(fontSize: 24),
      );
    } else {
      // Show 🔥x4 format for 4+
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          Text('x$streak', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyPress,
      child: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Badminton Counter'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareScreenshot,
                tooltip: 'Share Screenshot',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetGame,
                tooltip: 'Reset Game',
              ),
            ],
          ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Speech and Touch Mode Controls
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.record_voice_over),
                                  const SizedBox(width: 8),
                                  const Text('Speech Score:'),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: speechEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        speechEnabled = value;
                                      });
                                      _savePreferences();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.touch_app),
                                  const SizedBox(width: 8),
                                  const Text('Touch Mode:'),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: touchMode,
                                    onChanged: (value) {
                                      setState(() {
                                        touchMode = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Total Points Display
                      Card(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 32),
                              const SizedBox(width: 12),
                              Text(
                                'Total Points: $totalPoints',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Score Display
                      Row(
                        children: [
                          // Left Player
                          Expanded(
                            child: GestureDetector(
                              onTap: touchMode ? _incrementLeft : null,
                              child: Card(
                                color: Colors.blue.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        leftPlayerName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '$leftScore',
                                        style: const TextStyle(
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildStreakIndicator(leftStreak),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _decrementLeft,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('[-]'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Right Player
                          Expanded(
                            child: GestureDetector(
                              onTap: touchMode ? _incrementRight : null,
                              child: Card(
                                color: Colors.green.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        rightPlayerName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '$rightScore',
                                        style: const TextStyle(
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildStreakIndicator(rightStreak),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _decrementRight,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('[-]'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Quick Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _incrementLeft,
                            icon: const Icon(Icons.add),
                            label: Text(leftPlayerName),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _incrementRight,
                            icon: const Icon(Icons.add),
                            label: Text(rightPlayerName),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Control Hint
                      Card(
                        color: Colors.grey.shade100,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Tip: Tap the score boxes to increment, or use keyboard shortcuts!\nLeft/Right arrows or A/D to score, Z/C to decrease, R to reset.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


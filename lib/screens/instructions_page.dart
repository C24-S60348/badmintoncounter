import 'package:flutter/material.dart';
import 'suggestions_page.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.sports_tennis, size: 64, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Badminton Counter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track your badminton scores with ease!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Control Methods
          _buildSectionTitle('Control Methods'),
          _buildControlCard(
            'Touch Control',
            Icons.touch_app,
            Colors.blue,
            [
              'Tap on the score boxes to increment the score',
              'Tap the [-] button to decrement the score',
              'Enable Touch Mode switch to use this method',
            ],
          ),
          _buildControlCard(
            'Mouse Control',
            Icons.mouse,
            Colors.green,
            [
              'Left click to increment left player score',
              'Right click to increment right player score',
              'Middle click to toggle touch mode',
              'Click on [-] buttons to decrement',
            ],
          ),
          _buildControlCard(
            'Keyboard Shortcuts',
            Icons.keyboard,
            Colors.orange,
            [
              '← / A key: Increment left player score',
              '→ / D key: Increment right player score',
              'Z key: Decrement left player score',
              'C key: Decrement right player score',
              'R key: Reset game',
              'S key: Toggle speech score',
            ],
          ),
          const SizedBox(height: 24),

          // Features
          _buildSectionTitle('Features'),
          _buildFeatureCard(
            'Streak Indicator',
            Icons.local_fire_department,
            Colors.red,
            'Shows consecutive points: 🔥 (1), 🔥🔥 (2), 🔥🔥🔥 (3), then 🔥x4, 🔥x5, etc. for 4+ points.',
          ),
          _buildFeatureCard(
            'Speech Score',
            Icons.record_voice_over,
            Colors.purple,
            'Enable the Speech Score switch to hear the score announced after each point.',
          ),
          _buildFeatureCard(
            'Total Points',
            Icons.star,
            Colors.amber,
            'Tracks the total number of points scored across all games (persists even after reset).',
          ),
          _buildFeatureCard(
            'History',
            Icons.history,
            Colors.teal,
            'Save completed games to history with player names and remarks. You can edit history entries later.',
          ),
          _buildFeatureCard(
            'Summary',
            Icons.bar_chart,
            Colors.indigo,
            'View player statistics including wins, losses, win rate, average points, and leaderboard.',
          ),
          _buildFeatureCard(
            'Share Screenshot',
            Icons.share,
            Colors.pink,
            'Capture and share a screenshot of the current score with friends.',
          ),
          const SizedBox(height: 24),

          // How to Use
          _buildSectionTitle('How to Use'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep('1', 'Start Scoring',
                      'Use any control method (touch, mouse, or keyboard) to increment scores as players win points.'),
                  const Divider(height: 24),
                  _buildStep('2', 'Monitor Streaks',
                      'Watch for fire emojis (🔥) showing consecutive points. They appear after the first point in a streak!'),
                  const Divider(height: 24),
                  _buildStep('3', 'Complete Game',
                      'When the game is finished, tap the reset button to save the game to history.'),
                  const Divider(height: 24),
                  _buildStep('4', 'Review History',
                      'Check the History tab to see past games. Tap any entry to edit details.'),
                  const Divider(height: 24),
                  _buildStep('5', 'View Summary',
                      'Go to the Summary tab to see player statistics and leaderboard.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tips
          _buildSectionTitle('Tips & Tricks'),
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Pro Tips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('• Use keyboard shortcuts for fastest score keeping'),
                  SizedBox(height: 8),
                  Text('• Enable speech score during intense matches'),
                  SizedBox(height: 8),
                  Text('• Add remarks in history for memorable games'),
                  SizedBox(height: 8),
                  Text('• Share screenshots to social media'),
                  SizedBox(height: 8),
                  Text('• Check Summary regularly to track improvement'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuggestionsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.feedback),
                  label: const Text('Send Suggestions'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement review link to app store
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Review on Store'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Version Info
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '© 2026 Badminton Counter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildControlCard(
    String title,
    IconData icon,
    Color color,
    List<String> points,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(51), // 0.2 opacity
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...points.map((point) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(color: color)),
                      Expanded(child: Text(point)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    Color color,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(51), // 0.2 opacity
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


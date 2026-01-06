import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  Map<String, Map<String, int>> playerStats = {};
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  String userId = 'user123';

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? 'user123';

    final data = await ApiService.getHistory(userId);
    _calculateStats(data);

    setState(() {
      history = data;
      isLoading = false;
    });
  }

  void _calculateStats(List<Map<String, dynamic>> data) {
    playerStats.clear();

    for (var entry in data) {
      final score = entry['score'] ?? '0-0';
      final scores = score.split('-');
      
      if (scores.length != 2) continue;

      final leftScore = int.tryParse(scores[0]) ?? 0;
      final rightScore = int.tryParse(scores[1]) ?? 0;
      
      final leftPlayer = entry['playerleft'] ?? 'Left';
      final rightPlayer = entry['playerright'] ?? 'Right';

      // Initialize player stats if not exists
      if (!playerStats.containsKey(leftPlayer)) {
        playerStats[leftPlayer] = {
          'wins': 0,
          'losses': 0,
          'totalPoints': 0,
          'games': 0,
        };
      }
      if (!playerStats.containsKey(rightPlayer)) {
        playerStats[rightPlayer] = {
          'wins': 0,
          'losses': 0,
          'totalPoints': 0,
          'games': 0,
        };
      }

      // Update stats
      playerStats[leftPlayer]!['games'] = playerStats[leftPlayer]!['games']! + 1;
      playerStats[leftPlayer]!['totalPoints'] = 
          playerStats[leftPlayer]!['totalPoints']! + leftScore;

      playerStats[rightPlayer]!['games'] = playerStats[rightPlayer]!['games']! + 1;
      playerStats[rightPlayer]!['totalPoints'] = 
          playerStats[rightPlayer]!['totalPoints']! + rightScore;

      if (leftScore > rightScore) {
        playerStats[leftPlayer]!['wins'] = playerStats[leftPlayer]!['wins']! + 1;
        playerStats[rightPlayer]!['losses'] = playerStats[rightPlayer]!['losses']! + 1;
      } else if (rightScore > leftScore) {
        playerStats[rightPlayer]!['wins'] = playerStats[rightPlayer]!['wins']! + 1;
        playerStats[leftPlayer]!['losses'] = playerStats[leftPlayer]!['losses']! + 1;
      }
    }
  }

  Widget _buildPlayerCard(String playerName, Map<String, int> stats) {
    final wins = stats['wins'] ?? 0;
    final losses = stats['losses'] ?? 0;
    final totalGames = stats['games'] ?? 0;
    final totalPoints = stats['totalPoints'] ?? 0;
    final winRate = totalGames > 0 ? (wins / totalGames * 100).toStringAsFixed(1) : '0.0';
    final avgPoints = totalGames > 0 ? (totalPoints / totalGames).toStringAsFixed(1) : '0.0';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$totalGames games played',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: wins > losses ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$winRate%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Wins',
                  wins.toString(),
                  Icons.emoji_events,
                  Colors.green,
                ),
                _buildStatItem(
                  'Losses',
                  losses.toString(),
                  Icons.trending_down,
                  Colors.red,
                ),
                _buildStatItem(
                  'Avg Points',
                  avgPoints,
                  Icons.star,
                  Colors.amber,
                ),
                _buildStatItem(
                  'Total Points',
                  totalPoints.toString(),
                  Icons.sports_score,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    final sortedPlayers = playerStats.entries.toList()
      ..sort((a, b) {
        final aWins = a.value['wins'] ?? 0;
        final bWins = b.value['wins'] ?? 0;
        return bWins.compareTo(aWins);
      });

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.leaderboard, size: 28, color: Colors.amber),
                const SizedBox(width: 12),
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...sortedPlayers.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              final wins = player.value['wins'] ?? 0;
              final games = player.value['games'] ?? 0;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: index == 0
                      ? Colors.amber.shade50
                      : index == 1
                          ? Colors.grey.shade100
                          : index == 2
                              ? Colors.brown.shade50
                              : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Colors.amber
                            : index == 1
                                ? Colors.grey
                                : index == 2
                                    ? Colors.brown
                                    : Colors.blue.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        player.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '$wins wins',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($games games)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSummary,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : playerStats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No data yet',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Play some games to see statistics',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSummary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildLeaderboard(),
                        const SizedBox(height: 8),
                        ...playerStats.entries.map((entry) {
                          return _buildPlayerCard(entry.key, entry.value);
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
    );
  }
}


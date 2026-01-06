import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://afwanhaziq.vps.webdock.cloud';

  // Get history for a user
  static Future<List<Map<String, dynamic>>> getHistory(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/badminton/api/gethistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userid': userId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      // Log error - in production, use proper logging
      // print('Error fetching history: $e');
      return [];
    }
  }

  // Insert new history entry
  static Future<bool> insertHistory({
    required String userId,
    required String date,
    required String time,
    required String score,
    required String playerLeft,
    required String playerRight,
    String remark = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/badminton/api/inserthistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userId,
          'date': date,
          'time': time,
          'score': score,
          'playerleft': playerLeft,
          'playerright': playerRight,
          'remark': remark,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // Log error - in production, use proper logging
      // print('Error inserting history: $e');
      return false;
    }
  }

  // Update history entry
  static Future<bool> updateHistory({
    required String id,
    required String userId,
    required String date,
    required String time,
    required String score,
    required String playerLeft,
    required String playerRight,
    String remark = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/badminton/api/updatehistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'userid': userId,
          'date': date,
          'time': time,
          'score': score,
          'playerleft': playerLeft,
          'playerright': playerRight,
          'remark': remark,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // Log error - in production, use proper logging
      // print('Error updating history: $e');
      return false;
    }
  }

  // Submit suggestion
  static Future<bool> submitSuggestion({
    required String name,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/badminton/api/insertsuggestions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'comment': comment,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // Log error - in production, use proper logging
      // print('Error submitting suggestion: $e');
      return false;
    }
  }
}


import 'package:shared_preferences/shared_preferences.dart';

class RequestManager {
  static const int requestLimit = 150;
  static const String _requestCountKey = 'request_count';
  static const String _lastRequestDateKey = 'last_request_date';

  static Future<bool> canMakeRequest() async {
    final prefs = await SharedPreferences.getInstance();

    // Get current date as a string
    final today = DateTime.now().toIso8601String().split('T').first;

    // Get last request date and count from storage
    final lastRequestDate = prefs.getString(_lastRequestDateKey) ?? '';
    int requestCount = prefs.getInt(_requestCountKey) ?? 0;

    // Reset count if the date has changed
    if (lastRequestDate != today) {
      await prefs.setString(_lastRequestDateKey, today);
      await prefs.setInt(_requestCountKey, 0);
      requestCount = 0;
    }

    // Check if the request count has reached the limit
    if (requestCount >= requestLimit) {
      return false;
    }

    return true;
  }

  static Future<void> incrementRequestCount() async {
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt(_requestCountKey) ?? 0;
    await prefs.setInt(_requestCountKey, currentCount + 1);
  }
}

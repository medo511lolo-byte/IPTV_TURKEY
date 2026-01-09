import 'dart:convert';
import 'package:http/http.dart' as http;

class XtreamAPI {
  static Future<List<dynamic>> getLiveChannels(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_live_streams";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load channels');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getLiveCategories(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_live_categories";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load live categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // جلب معلومات الحساب وتاريخ انتهاء الاشتراك
  static Future<Map<String, dynamic>> getAccountInfo(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_account_info";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load account info');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchHistoryService {
  static const String _key = 'watch_history';
  static const int _maxItems = 5;

  // حفظ عنصر في آخر المشاهدة
  static Future<void> addToHistory({
    required String id,
    required String name,
    required String type, // 'live', 'movie', 'series'
    String? poster,
    String? url,
    Map<String, dynamic>? extraData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_key);
    
    List<Map<String, dynamic>> history = [];
    if (historyJson != null) {
      history = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
    }

    // إزالة العنصر إذا كان موجوداً مسبقاً
    history.removeWhere((item) => item['id'] == id && item['type'] == type);

    // إضافة العنصر الجديد في البداية
    history.insert(0, {
      'id': id,
      'name': name,
      'type': type,
      'poster': poster,
      'url': url,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?extraData,
    });

    // الاحتفاظ بآخر 5 عناصر فقط
    if (history.length > _maxItems) {
      history = history.sublist(0, _maxItems);
    }

    await prefs.setString(_key, jsonEncode(history));
  }

  // جلب آخر المشاهدات
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_key);
    
    if (historyJson == null) return [];
    
    return List<Map<String, dynamic>>.from(jsonDecode(historyJson));
  }

  // مسح آخر المشاهدات
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // حذف عنصر محدد
  static Future<void> removeItem(String id, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_key);
    
    if (historyJson == null) return;
    
    List<Map<String, dynamic>> history = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
    history.removeWhere((item) => item['id'] == id && item['type'] == type);
    
    await prefs.setString(_key, jsonEncode(history));
  }
}

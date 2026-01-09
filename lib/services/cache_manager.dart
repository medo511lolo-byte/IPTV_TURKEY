import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _cacheTimestampSuffix = '_timestamp';
  static const Duration _cacheExpiration = Duration(hours: 24);

  // حفظ البيانات مع الطابع الزمني
  static Future<bool> saveData({
    required String type, // 'live', 'movies', 'series'
    required Map<String, dynamic> data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'cache_$type';
      final timestampKey = '$key$_cacheTimestampSuffix';
      final jsonString = jsonEncode(data);
      
      await prefs.setString(key, jsonString);
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // تحميل البيانات
  static Future<Map<String, dynamic>?> loadData({
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'cache_$type';
      final jsonString = prefs.getString(key);
      
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // التحقق من انتهاء صلاحية الكاش
  static Future<bool> isCacheExpired({
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampKey = 'cache_$type$_cacheTimestampSuffix';
      final timestamp = prefs.getInt(timestampKey);
      
      if (timestamp == null) {
        return true;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference > _cacheExpiration;
    } catch (e) {
      return true;
    }
  }

  // الحصول على وقت آخر تحديث
  static Future<DateTime?> getLastUpdateTime({
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampKey = 'cache_$type$_cacheTimestampSuffix';
      final timestamp = prefs.getInt(timestampKey);
      
      if (timestamp == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }

  // حذف البيانات المحفوظة
  static Future<bool> clearData({
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'cache_$type';
      final timestampKey = '$key$_cacheTimestampSuffix';
      await prefs.remove(key);
      await prefs.remove(timestampKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // حذف كل البيانات المخزنة
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final types = ['live', 'movies', 'series'];
      for (final type in types) {
        final key = 'cache_$type';
        await prefs.remove(key);
        await prefs.remove('$key$_cacheTimestampSuffix');
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // التحقق من وجود بيانات محفوظة
  static Future<bool> hasCache({
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'cache_$type';
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  // الحصول على حجم البيانات المحفوظة (بالكيلوبايت)
  static Future<double> getCacheSize({
    required String type,
  }) async {
    try {
      final data = await loadData(
        type: type,
      );
      
      if (data == null) {
        return 0;
      }

      final jsonString = jsonEncode(data);
      return jsonString.length / 1024; // تحويل إلى KB
    } catch (e) {
      return 0;
    }
  }
}

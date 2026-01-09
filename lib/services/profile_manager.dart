import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

class ProfileManager {
  static const String _profilesKey = 'user_profiles';
  static const String _activeProfileKey = 'active_profile_id';
  static const int maxProfiles = 2;

  // حفظ البروفايلات
  static Future<bool> saveProfiles(List<UserProfile> profiles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = profiles.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_profilesKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  // تحميل البروفايلات
  static Future<List<UserProfile>> loadProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_profilesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // إضافة بروفايل جديد
  static Future<bool> addProfile(UserProfile profile) async {
    final profiles = await loadProfiles();
    
    // التحقق من الحد الأقصى
    if (profiles.length >= maxProfiles) {
      return false;
    }

    // التحقق من عدم تكرار اليوزرنيم
    if (profiles.any((p) => p.username == profile.username)) {
      return false;
    }

    profiles.add(profile);
    return await saveProfiles(profiles);
  }

  // تحديث بروفايل
  static Future<bool> updateProfile(UserProfile profile) async {
    final profiles = await loadProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);
    
    if (index == -1) {
      return false;
    }

    profiles[index] = profile;
    return await saveProfiles(profiles);
  }

  // حذف بروفايل
  static Future<bool> deleteProfile(String profileId) async {
    final profiles = await loadProfiles();
    profiles.removeWhere((p) => p.id == profileId);
    
    // حذف البيانات المحفوظة للبروفايل
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cache_live_$profileId');
    await prefs.remove('cache_movies_$profileId');
    await prefs.remove('cache_series_$profileId');
    
    return await saveProfiles(profiles);
  }

  // تعيين البروفايل النشط
  static Future<bool> setActiveProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_activeProfileKey, profileId);
  }

  // الحصول على البروفايل النشط
  static Future<UserProfile?> getActiveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileId = prefs.getString(_activeProfileKey);
      
      if (profileId == null) {
        return null;
      }

      final profiles = await loadProfiles();
      return profiles.firstWhere(
        (p) => p.id == profileId,
        orElse: () => throw Exception('Profile not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // مسح البروفايل النشط
  static Future<bool> clearActiveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_activeProfileKey);
  }

  // التحقق من إمكانية إضافة بروفايل جديد
  static Future<bool> canAddProfile() async {
    final profiles = await loadProfiles();
    return profiles.length < maxProfiles;
  }
}

# 🎯 دليل التطوير والتحسين

## 🚀 خطوات التشغيل السريع

### التثبيت
```bash
# تثبيت التبعيات
flutter pub get

# تشغيل على Android
flutter run

# تشغيل على iOS
flutter run -d ios
```

## 📝 كيفية الاستخدام

### بيانات تسجيل الدخول
يجب أن تكون بيانات Xtream Codes على الشكل التالي:
- **Server URL**: http://example.com:8080 (مع http:// أو https://)
- **Username**: your_username
- **Password**: your_password

### مثال على رابط Stream
```
http://server:port/live/username/password/stream_id.ts
```

## 🔧 التطويرات الممكنة

### 1. إضافة SharedPreferences لحفظ بيانات الدخول
```dart
import 'package:shared_preferences/shared_preferences.dart';

// حفظ البيانات
Future<void> saveCredentials(String server, String user, String pass) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('server', server);
  await prefs.setString('username', user);
  await prefs.setString('password', pass);
}

// قراءة البيانات
Future<Map<String, String>> loadCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'server': prefs.getString('server') ?? '',
    'username': prefs.getString('username') ?? '',
    'password': prefs.getString('password') ?? '',
  };
}
```

### 2. إضافة Categories (الفئات)
```dart
// في xtream_api.dart
static Future<List<dynamic>> getCategories(
  String server,
  String user,
  String pass,
) async {
  final url = "$server/player_api.php?username=$user&password=$pass&action=get_live_categories";
  final res = await http.get(Uri.parse(url));
  return json.decode(res.body);
}
```

### 3. إضافة VOD (Movies & Series)
```dart
// للأفلام
static Future<List<dynamic>> getMovies(...) async {
  final url = "$server/player_api.php?username=$user&password=$pass&action=get_vod_streams";
  ...
}

// للمسلسلات
static Future<List<dynamic>> getSeries(...) async {
  final url = "$server/player_api.php?username=$user&password=$pass&action=get_series";
  ...
}
```

### 4. إضافة EPG (جدول البرامج)
```dart
static Future<dynamic> getEPG(
  String server,
  String user,
  String pass,
  String streamId,
) async {
  final url = "$server/player_api.php?username=$user&password=$pass&action=get_simple_data_table&stream_id=$streamId";
  ...
}
```

### 5. إضافة Search (البحث)
```dart
class SearchScreen extends StatefulWidget {
  final List<Channel> channels;
  
  // تصفية القنوات حسب النص المدخل
  List<Channel> filterChannels(String query) {
    return channels
        .where((ch) => ch.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
```

### 6. إضافة Favorites (المفضلة)
```dart
// حفظ المفضلات في SharedPreferences
Future<void> addToFavorites(String streamId) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> favorites = prefs.getStringList('favorites') ?? [];
  if (!favorites.contains(streamId)) {
    favorites.add(streamId);
    await prefs.setStringList('favorites', favorites);
  }
}

Future<List<String>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('favorites') ?? [];
}
```

## 🎨 تحسينات الواجهة

### إضافة صور القنوات
في `live_tv.dart`:
```dart
ListTile(
  leading: channels[i]['stream_icon'] != null
      ? Image.network(
          channels[i]['stream_icon'],
          width: 50,
          errorBuilder: (_, __, ___) => Icon(Icons.tv),
        )
      : Icon(Icons.tv),
  title: Text(channels[i]['name']),
  ...
)
```

### إضافة Dark Mode
```dart
// في main.dart
return MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system, // أو .light أو .dark
  ...
)
```

## 🐛 حل المشاكل الشائعة

### مشكلة: القنوات لا تظهر
- تأكد من صحة بيانات الدخول
- تحقق من أن الخادم يعمل
- افحص الـ API response في console

### مشكلة: الفيديو لا يعمل
- تأكد من إضافة `android:usesCleartextTraffic="true"` في Android
- تأكد من إضافة `NSAppTransportSecurity` في iOS
- جرب رابط القناة في المتصفح

### مشكلة: بطء في التحميل
- أضف Loading indicator
- استخدم caching للصور
- قلل عدد القنوات المعروضة (Pagination)

## 📦 تبعيات إضافية مفيدة

```yaml
dependencies:
  # للتخزين المحلي
  sqflite: ^2.3.0
  
  # لإدارة الحالة
  provider: ^6.1.0
  
  # للصور
  cached_network_image: ^3.3.0
  
  # للأيقونات
  font_awesome_flutter: ^10.6.0
  
  # للـ Splash Screen
  flutter_native_splash: ^2.3.0
```

## 🔐 الأمان

**تحذير**: لا تضع بيانات الدخول الحقيقية في الكود!

استخدم:
- Environment Variables
- Secure Storage للبيانات الحساسة
- تشفير البيانات المحفوظة محلياً

## 📱 Build للإنتاج

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (للـ Play Store)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 📊 الأداء

### تحسين الأداء
- استخدم `const` للـ widgets الثابتة
- استخدم `ListView.builder` بدلاً من `ListView`
- أضف caching للـ API responses
- استخدم Image caching

---

**ملاحظة**: هذا مشروع تعليمي. تأكد من احترام حقوق البث والملكية الفكرية.

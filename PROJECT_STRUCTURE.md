# 🏗️ شرح هيكل المشروع

## 📂 البنية الكاملة للمشروع

```
IPTV_TURKEY/
│
├── android/                          # مجلد Android
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml   # إعدادات Android (الأذونات)
│
├── ios/                              # مجلد iOS
│   └── Runner/
│       └── Info.plist                # إعدادات iOS (الأمان)
│
├── lib/                              # الكود الرئيسي للتطبيق
│   ├── main.dart                     # نقطة البداية
│   │
│   ├── screens/                      # شاشات التطبيق
│   │   ├── login.dart               # شاشة تسجيل الدخول
│   │   ├── home.dart                # الصفحة الرئيسية
│   │   ├── live_tv.dart             # شاشة عرض القنوات
│   │   └── player.dart              # شاشة المشغّل
│   │
│   ├── services/                     # الخدمات والـ API
│   │   └── xtream_api.dart          # التواصل مع Xtream API
│   │
│   └── models/                       # نماذج البيانات
│       └── channel.dart             # نموذج القناة
│
├── pubspec.yaml                      # تبعيات المشروع
├── analysis_options.yaml             # إعدادات التحليل
├── .gitignore                        # ملفات Git المهملة
│
├── README.md                         # الوثائق الرئيسية
├── QUICKSTART.md                     # دليل البداية السريع
├── DEVELOPMENT.md                    # دليل التطوير المتقدم
└── TEST_CREDENTIALS_EXAMPLE.md       # مثال على البيانات

```

---

## 📄 شرح كل ملف

### 🎯 main.dart
نقطة بداية التطبيق
- ينشئ `MaterialApp`
- يحدد الشاشة الأولى (`LoginScreen`)
- يضبط الإعدادات العامة للتطبيق

**المسؤوليات:**
- تهيئة التطبيق
- إعداد Theme
- تحديد الصفحة الأولى

---

### 🔐 screens/login.dart
شاشة تسجيل الدخول

**المكونات:**
- 3 حقول إدخال: Server URL, Username, Password
- زر LOGIN
- تصميم بسيط ونظيف

**الوظيفة:**
- جمع بيانات المستخدم
- الانتقال إلى `HomeScreen` مع تمرير البيانات

**التحسينات المستقبلية:**
- التحقق من صحة البيانات
- حفظ البيانات تلقائياً
- زر "تذكرني"

---

### 🏠 screens/home.dart
الصفحة الرئيسية

**المكونات:**
- أيقونة كبيرة
- زر "Live TV"

**الوظيفة:**
- صفحة وسيطة للتنقل
- تعرض الخيارات المتاحة

**التحسينات المستقبلية:**
- إضافة أزرار لـ VOD, Series
- عرض معلومات الحساب
- إضافة drawer menu

---

### 📺 screens/live_tv.dart
شاشة عرض القنوات

**المكونات:**
- `FutureBuilder` لجلب البيانات
- `ListView.builder` لعرض القنوات
- معالجة الأخطاء
- مؤشر التحميل

**الوظيفة:**
- جلب القنوات من API
- عرضها في قائمة
- الانتقال للمشغّل عند الضغط

**التحسينات المستقبلية:**
- إضافة صور القنوات
- تصنيف القنوات (Categories)
- البحث
- قائمة المفضلة

---

### 🎥 screens/player.dart
شاشة مشغّل الفيديو

**المكونات:**
- `BetterPlayerController`
- شريط تحكم كامل
- دعم Fullscreen

**الوظيفة:**
- تشغيل البث المباشر
- التحكم بالصوت والصورة
- دعم الوضع الأفقي

**المميزات:**
- تشغيل تلقائي
- نسبة عرض 16:9
- أزرار تحكم كاملة

**التحسينات المستقبلية:**
- تبديل الجودة
- الترجمة
- Picture in Picture

---

### 🌐 services/xtream_api.dart
خدمة التواصل مع API

**الوظائف الحالية:**
- `getLiveChannels()` - جلب القنوات المباشرة

**الصيغة:**
```dart
http://server/player_api.php?username=USER&password=PASS&action=get_live_streams
```

**التحسينات المستقبلية:**
```dart
getCategories()       // الفئات
getMovies()          // الأفلام
getSeries()          // المسلسلات
getAccountInfo()     // معلومات الحساب
getEPG()            // جدول البرامج
```

**معالجة الأخطاء:**
- try/catch blocks
- status code checking
- error messages

---

### 📦 models/channel.dart
نموذج بيانات القناة

**الحقول:**
- `streamId` - معرف القناة
- `name` - اسم القناة
- `streamIcon` - أيقونة القناة
- `categoryId` - الفئة
- وغيرها...

**الوظائف:**
- `fromJson()` - تحويل من JSON
- `toJson()` - تحويل إلى JSON

**الاستخدام:**
```dart
Channel channel = Channel.fromJson(jsonData);
```

---

## ⚙️ الملفات التكوينية

### 📦 pubspec.yaml
**التبعيات الأساسية:**
- `http: ^1.2.0` - طلبات HTTP
- `better_player: ^0.0.84` - مشغّل الفيديو
- `shared_preferences: ^2.2.2` - التخزين المحلي

**إعدادات المشروع:**
- اسم المشروع
- الإصدار
- متطلبات SDK

---

### 🔍 analysis_options.yaml
**الإعدادات:**
- تعطيل بعض التحذيرات
- قواعد Linting
- تنسيق الكود

---

### 📱 AndroidManifest.xml
**الإعدادات الهامة:**
```xml
android:usesCleartextTraffic="true"  # السماح بـ HTTP
```

**الأذونات:**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

---

### 🍎 Info.plist (iOS)
**الإعدادات الهامة:**
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

يسمح بالاتصالات HTTP غير المشفرة

---

## 🔄 سير عمل التطبيق (Flow)

```
1. main.dart
   ↓
2. LoginScreen (إدخال البيانات)
   ↓
3. HomeScreen (عرض الخيارات)
   ↓
4. LiveTVScreen (جلب وعرض القنوات)
   ↓ (عند الضغط على قناة)
5. PlayerScreen (تشغيل القناة)
```

---

## 📊 تدفق البيانات (Data Flow)

```
User Input (LoginScreen)
    ↓
Pass credentials to HomeScreen
    ↓
Pass credentials to LiveTVScreen
    ↓
XtreamAPI.getLiveChannels() → HTTP Request
    ↓
Server Response (JSON)
    ↓
Parse & Display in ListView
    ↓
User selects channel
    ↓
Build stream URL
    ↓
Pass to PlayerScreen
    ↓
BetterPlayer plays stream
```

---

## 🎨 التصميم (UI/UX)

### الألوان:
- Primary: Blue (`Colors.blue`)
- يمكن تخصيصها في `ThemeData`

### الأيقونات:
- `Icons.tv` - للقنوات
- `Icons.play_arrow` - للتشغيل
- `Icons.person`, `Icons.lock` - للدخول

### التخطيط:
- Material Design 3
- Responsive
- يدعم Portrait & Landscape

---

## 🔐 الأمان

### ما تم تطبيقه:
✅ معالجة الأخطاء الأساسية
✅ التحقق من صحة الاستجابات

### ما يجب إضافته:
❌ تشفير البيانات المحلية
❌ Secure Storage للبيانات الحساسة
❌ HTTPS فقط للإنتاج
❌ Token-based authentication

---

## 📈 الأداء

### نقاط القوة:
- استخدام `ListView.builder` (فعّال للقوائم الطويلة)
- `FutureBuilder` (تحميل غير متزامن)
- `const` constructors حيثما أمكن

### التحسينات المستقبلية:
- إضافة Caching للـ API responses
- Image caching
- Pagination للقنوات
- State management (Provider/Bloc)

---

## 🧪 الاختبار

### يمكن إضافة:
```dart
test/
├── unit_tests/
│   └── xtream_api_test.dart
├── widget_tests/
│   └── login_screen_test.dart
└── integration_tests/
    └── app_test.dart
```

---

## 📚 المصادر المفيدة

- [Flutter Documentation](https://flutter.dev/docs)
- [Better Player Docs](https://pub.dev/packages/better_player)
- [Xtream Codes API](http://example.com/player_api.php)

---

**تم شرح كل شيء بالتفصيل! 🎉**

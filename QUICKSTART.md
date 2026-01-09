# 📺 مشروع IPTV Turkey - دليل البداية السريع

## ✅ المشروع جاهز تماماً!

تم إنشاء مشغّل IPTV كامل باستخدام Flutter يعمل على Android و iOS.

---

## 📁 الملفات الموجودة

### ملفات المشروع الأساسية:
- ✅ `pubspec.yaml` - التبعيات والإعدادات
- ✅ `lib/main.dart` - نقطة البداية
- ✅ `README.md` - الوثائق الكاملة
- ✅ `DEVELOPMENT.md` - دليل التطوير المتقدم

### ملفات الشاشات:
- ✅ `lib/screens/login.dart` - شاشة تسجيل الدخول
- ✅ `lib/screens/home.dart` - الصفحة الرئيسية
- ✅ `lib/screens/live_tv.dart` - عرض القنوات
- ✅ `lib/screens/player.dart` - مشغّل الفيديو

### الخدمات والنماذج:
- ✅ `lib/services/xtream_api.dart` - API للتواصل مع الخادم
- ✅ `lib/models/channel.dart` - نموذج القناة

### إعدادات المنصات:
- ✅ `android/app/src/main/AndroidManifest.xml` - إعدادات Android
- ✅ `ios/Runner/Info.plist` - إعدادات iOS

---

## 🚀 خطوات التشغيل

### 1️⃣ تثبيت التبعيات
```bash
flutter pub get
```

### 2️⃣ تشغيل التطبيق
```bash
# على Android
flutter run

# على iOS
flutter run -d ios
```

### 3️⃣ اختبار التطبيق
1. أدخل بيانات خادم Xtream Codes:
   - Server URL: `http://example.com:8080`
   - Username: `your_username`
   - Password: `your_password`

2. اضغط على LOGIN

3. من الصفحة الرئيسية، اضغط على "Live TV"

4. اختر أي قناة للبدء بالمشاهدة

---

## 🎯 المميزات المتوفرة

✅ تسجيل دخول بنظام Xtream Codes  
✅ عرض قائمة القنوات المباشرة  
✅ تشغيل القنوات بمشغّل متقدم  
✅ واجهة مستخدم جميلة وسهلة  
✅ دعم Android و iOS  
✅ معالجة الأخطاء  
✅ مؤشرات التحميل  

---

## 🛠️ المميزات التي يمكن إضافتها لاحقاً

⭐ حفظ بيانات الدخول تلقائياً  
⭐ قائمة المفضلة  
⭐ البحث في القنوات  
⭐ تصنيفات القنوات  
⭐ الأفلام والمسلسلات (VOD)  
⭐ جدول البرامج (EPG)  
⭐ الوضع الليلي (Dark Mode)  
⭐ عرض صور القنوات  

راجع ملف `DEVELOPMENT.md` للتفاصيل الكاملة.

---

## 📱 Build للنشر

### Android APK
```bash
flutter build apk --release
```
الملف سيكون في: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## ⚠️ ملاحظات مهمة

1. **الاتصالات غير الآمنة (HTTP)**:
   - تم إعداد Android و iOS للسماح بـ HTTP
   - للإنتاج، استخدم HTTPS

2. **الأذونات**:
   - تم إضافة أذونات الإنترنت تلقائياً
   - تم إضافة WAKE_LOCK لمنع إيقاف الشاشة أثناء التشغيل

3. **الأداء**:
   - جودة التشغيل تعتمد على سرعة الإنترنت
   - تأكد من صحة روابط الخادم

---

## 🐛 حل المشاكل

### القنوات لا تظهر؟
- تأكد من صحة بيانات الدخول
- تحقق من أن الخادم يعمل
- تأكد من وجود اتصال بالإنترنت

### الفيديو لا يعمل؟
- جرب القناة على متصفح الويب أولاً
- تأكد من أن الرابط صحيح
- قد تحتاج بعض القنوات لـ VPN

### أخطاء في التثبيت؟
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📞 الدعم والتطوير

لمزيد من المعلومات:
- اقرأ `README.md` للوثائق الكاملة
- اقرأ `DEVELOPMENT.md` لدليل التطوير
- استخدم `flutter doctor` للتحقق من الإعدادات

---

## 🎉 مبروك!

مشروعك جاهز للاستخدام والتطوير! 🚀

ابدأ الآن بتجربة التطبيق وتطويره حسب احتياجاتك.

---

**صُنع بـ ❤️ باستخدام Flutter**

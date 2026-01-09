# 🚀 دليل البناء السريع

## ⚡ خطوات سريعة للبناء

### 🤖 Android APK (للاختبار)

```bash
# 1. تنظيف المشروع
flutter clean

# 2. تحديث التبعيات
flutter pub get

# 3. البناء
flutter build apk --release

# 4. الملف موجود في:
# build/app/outputs/flutter-apk/app-release.apk
```

**الحجم المتوقع:** ~35 MB

---

### 📦 Android AAB (للمتجر)

```bash
# بعد إعداد التوقيع (انظر BUILD_GUIDE.md)
flutter build appbundle --release

# الملف موجود في:
# build/app/outputs/bundle/release/app-release.aab
```

**الحجم المتوقع:** ~30 MB

---

### 🍎 iOS IPA

```bash
# 1. تحديث Pods
cd ios
pod install
cd ..

# 2. البناء
flutter build ios --release

# 3. افتح Xcode وقم بـ Archive
open ios/Runner.xcworkspace
```

---

## 🔑 إعداد التوقيع (مرة واحدة)

### Android:

```bash
# 1. إنشاء المفتاح
cd android/app
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias iptv-turkey

# 2. أنشئ ملف android/key.properties:
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=iptv-turkey
storeFile=key.jks

# 3. راجع BUILD_GUIDE.md للتفاصيل
```

---

## ✅ Pre-Build Checklist

- [ ] `flutter doctor` بدون أخطاء
- [ ] تم اختبار التطبيق: `flutter run --release`
- [ ] تم تحديث الإصدار في `pubspec.yaml`
- [ ] تم إعداد الأيقونة
- [ ] تم إعداد التوقيع (للـ release)

---

## 🧪 اختبار APK

```bash
# تثبيت على جهاز متصل
flutter install

# أو يدوياً
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 📏 أحجام البناء

| النوع | الحجم | الاستخدام |
|------|------|---------|
| Debug APK | ~50-70 MB | التطوير فقط |
| Release APK | ~30-40 MB | الاختبار |
| Release AAB | ~25-35 MB | المتجر (موصى به) |
| iOS IPA | ~40-55 MB | المتجر |

---

## 🎯 للنشر السريع

1. **بناء AAB:**
   ```bash
   flutter build appbundle --release
   ```

2. **اذهب لـ Google Play Console**

3. **رفع AAB في Production**

4. **انتظر 1-3 أيام للمراجعة**

---

## 🐛 مشاكل شائعة

### خطأ في البناء؟
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### APK لا يعمل؟
- تأكد من `--release`
- تحقق من الأذونات في AndroidManifest.xml
- اختبر على جهاز حقيقي وليس emulator

### حجم APK كبير؟
```bash
# استخدم split per ABI
flutter build apk --release --split-per-abi
```

---

**للتفاصيل الكاملة، راجع [BUILD_GUIDE.md](BUILD_GUIDE.md)**

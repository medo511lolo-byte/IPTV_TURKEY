# 📱 دليل بناء التطبيق ونشره على المتاجر

## 📋 الجدول الزمني

- ⏱️ **Android APK**: 5 دقائق
- ⏱️ **Android AAB** (للمتجر): 10 دقائق
- ⏱️ **iOS IPA**: 15 دقيقة
- 🕒 **النشر على Google Play**: 1-3 أيام
- 🕒 **النشر على App Store**: 1-7 أيام

---

## 🤖 الجزء الأول: Android

### 1️⃣ إعداد الأيقونة

#### الخطوة 1: تجهيز الأيقونة
ضع أيقونة التطبيق (1024×1024 بكسل) في:
```
assets/icon/icon.png
```

**متطلبات الأيقونة:**
- الحجم: 1024×1024 بكسل
- الصيغة: PNG مع شفافية
- التصميم: بسيط وواضح

#### الخطوة 2: تثبيت أداة الأيقونات
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

هذا سيُنشئ تلقائياً جميع أحجام الأيقونات المطلوبة.

---

### 2️⃣ تحديث معلومات التطبيق

#### android/app/build.gradle

افتح الملف وعدّل:

```gradle
android {
    namespace "com.iptv.turkey"
    compileSdk 34

    defaultConfig {
        applicationId "com.iptv.turkey"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

**ملاحظة**: غيّر `applicationId` إلى اسم فريد لتطبيقك!

#### android/app/src/main/AndroidManifest.xml

تأكد من:
```xml
<application
    android:label="IPTV Turkey"
    android:icon="@mipmap/ic_launcher">
```

---

### 3️⃣ إعداد التوقيع الرقمي (مهم جداً!)

#### الخطوة 1: إنشاء مفتاح التوقيع

افتح Terminal وشغّل:

```bash
cd android/app
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias iptv-turkey
```

**ستُسأل عن:**
- Password: اختر كلمة مرور قوية (احفظها!)
- الاسم: اسمك أو اسم الشركة
- المدينة، البلد، إلخ: أدخل المعلومات

⚠️ **مهم جداً**: احفظ ملف `key.jks` وكلمة المرور في مكان آمن!

#### الخطوة 2: إنشاء ملف key.properties

أنشئ ملف `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=iptv-turkey
storeFile=key.jks
```

**استبدل:**
- `YOUR_STORE_PASSWORD` بكلمة المرور
- `YOUR_KEY_PASSWORD` بكلمة المرور (نفسها غالباً)

#### الخطوة 3: تحديث build.gradle

افتح `android/app/build.gradle` وأضف قبل `android {`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing code
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

---

### 4️⃣ بناء APK (للاختبار)

```bash
flutter clean
flutter pub get
flutter build apk --release
```

📦 **الملف سيكون في:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**الحجم المتوقع:** 30-50 MB

---

### 5️⃣ بناء AAB (للمتجر)

```bash
flutter build appbundle --release
```

📦 **الملف سيكون في:**
```
build/app/outputs/bundle/release/app-release.aab
```

**الحجم المتوقع:** 25-40 MB

---

### 6️⃣ اختبار APK

```bash
# تثبيت على جهاز متصل
flutter install

# أو يدوياً
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 🍎 الجزء الثاني: iOS

### 1️⃣ المتطلبات

- ✅ macOS
- ✅ Xcode 14+
- ✅ Apple Developer Account ($99/سنة)
- ✅ iPhone أو Simulator

---

### 2️⃣ إعداد المشروع

```bash
cd ios
pod install
cd ..
```

---

### 3️⃣ فتح في Xcode

```bash
open ios/Runner.xcworkspace
```

---

### 4️⃣ إعداد Signing

في Xcode:
1. اختر `Runner` من الجانب
2. في تبويب `Signing & Capabilities`:
   - Team: اختر Apple Developer Team
   - Bundle Identifier: `com.iptv.turkey` (غيّره لشيء فريد)
   - Signing Certificate: Automatic

---

### 5️⃣ تحديث المعلومات

في `ios/Runner/Info.plist`، تأكد من:
```xml
<key>CFBundleDisplayName</key>
<string>IPTV Turkey</string>

<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<key>CFBundleVersion</key>
<string>1</string>
```

---

### 6️⃣ بناء IPA

#### للاختبار (Simulator):
```bash
flutter build ios --simulator
```

#### للجهاز الحقيقي:
```bash
flutter build ios --release
```

ثم في Xcode:
1. اختر `Any iOS Device` من القائمة العلوية
2. `Product` → `Archive`
3. انتظر حتى ينتهي البناء
4. `Distribute App` → `Ad Hoc` أو `App Store`

---

## 📤 الجزء الثالث: رفع على المتاجر

### 🟢 Google Play Store

#### 1️⃣ إنشاء حساب Google Play Console

زر: https://play.google.com/console
رسوم التسجيل: $25 (مرة واحدة)

#### 2️⃣ إنشاء تطبيق جديد

1. اضغط `Create app`
2. أدخل:
   - اسم التطبيق
   - اللغة الافتراضية
   - نوع التطبيق: App
   - مجاني أو مدفوع

#### 3️⃣ تعبئة معلومات التطبيق

**Store listing:**
- العنوان (30 حرف)
- الوصف القصير (80 حرف)
- الوصف الكامل (4000 حرف)
- أيقونة: 512×512 بكسل
- Feature Graphic: 1024×500 بكسل
- Screenshots: على الأقل 2 (1080×1920)

**Content rating:**
- أكمل الاستبيان

**Target audience:**
- اختر الفئة العمرية

**Privacy policy:**
- أضف رابط سياسة الخصوصية

#### 4️⃣ رفع AAB

1. اذهب لـ `Production` → `Create new release`
2. ارفع ملف `app-release.aab`
3. أضف Release notes
4. `Review release`
5. `Start rollout to Production`

⏳ **المراجعة تستغرق:** 1-3 أيام

---

### 🔵 Apple App Store

#### 1️⃣ إنشاء حساب Apple Developer

زر: https://developer.apple.com
رسوم الاشتراك: $99/سنة

#### 2️⃣ إنشاء App ID

1. اذهب لـ `Certificates, Identifiers & Profiles`
2. `Identifiers` → `+` → `App IDs`
3. Bundle ID: `com.iptv.turkey`

#### 3️⃣ إنشاء التطبيق في App Store Connect

زر: https://appstoreconnect.apple.com

1. `My Apps` → `+` → `New App`
2. أدخل:
   - Platform: iOS
   - Name: IPTV Turkey
   - Primary Language: Arabic
   - Bundle ID: اختر من القائمة
   - SKU: iptv-turkey-001

#### 4️⃣ تعبئة معلومات التطبيق

**App Information:**
- Name
- Subtitle (30 حرف)
- Category: Entertainment
- Privacy Policy URL

**Pricing and Availability:**
- مجاني أو مدفوع
- الدول المتاحة

**App Store Screenshots:**
- iPhone 6.7": 1290×2796 (3 على الأقل)
- iPhone 6.5": 1242×2688

**Description:**
- Description (4000 حرف)
- Keywords (100 حرف)
- Support URL

#### 5️⃣ رفع IPA

من Xcode بعد Archive:
1. `Distribute App`
2. `App Store Connect`
3. `Upload`
4. انتظر حتى يظهر في App Store Connect

#### 6️⃣ إرسال للمراجعة

1. في App Store Connect، اختر البناء (Build)
2. أكمل جميع المعلومات المطلوبة
3. `Submit for Review`

⏳ **المراجعة تستغرق:** 1-7 أيام

---

## 🔧 نصائح مهمة

### ✅ قبل البناء:

```bash
# تنظيف المشروع
flutter clean

# تحديث التبعيات
flutter pub get

# فحص المشاكل
flutter doctor

# اختبار التطبيق
flutter run --release
```

### ✅ أثناء البناء:

- تأكد من الاتصال بالإنترنت
- استخدم Terminal بصلاحيات Admin
- لا تغلق Terminal أثناء البناء
- انتظر حتى تكتمل العملية

### ✅ بعد البناء:

- اختبر APK/IPA على جهاز حقيقي
- تحقق من جميع المميزات
- اختبر على شبكات مختلفة
- تأكد من الأذونات

---

## 📊 Checklist النشر

### Android:
- [ ] الأيقونة جاهزة
- [ ] applicationId فريد
- [ ] مفتاح التوقيع جاهز
- [ ] AAB تم بناؤه
- [ ] تم الاختبار على جهاز
- [ ] Screenshots جاهزة
- [ ] وصف التطبيق جاهز
- [ ] سياسة الخصوصية جاهزة

### iOS:
- [ ] الأيقونة جاهزة
- [ ] Bundle ID فريد
- [ ] Signing جاهز
- [ ] IPA تم بناؤه
- [ ] تم الاختبار على iPhone
- [ ] Screenshots جاهزة
- [ ] وصف التطبيق جاهز
- [ ] حساب Developer جاهز

---

## 🐛 حل المشاكل الشائعة

### مشكلة: خطأ في التوقيع

**الحل:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk --release
```

### مشكلة: APK كبير جداً

**الحل:**
استخدم AAB بدلاً من APK، وفعّل ProGuard:

في `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
    }
}
```

### مشكلة: خطأ في iOS Build

**الحل:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

---

## 📱 الأوامر السريعة

### Android:
```bash
# بناء APK
flutter build apk --release --split-per-abi

# بناء AAB
flutter build appbundle --release

# تثبيت
flutter install
```

### iOS:
```bash
# بناء
flutter build ios --release

# فتح Xcode
open ios/Runner.xcworkspace
```

---

## 🎉 بعد النشر

1. **راقب التقييمات**: رد على المستخدمين
2. **حدّث بانتظام**: أصلح الأخطاء وأضف مميزات
3. **تسويق**: شارك على السوشيال ميديا
4. **تحليلات**: استخدم Firebase Analytics

---

## 📞 موارد مفيدة

- [Flutter Documentation](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)

---

**تم! التطبيق جاهز للنشر 🚀**

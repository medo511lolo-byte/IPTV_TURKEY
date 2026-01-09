# GitHub Actions - بناء تطبيق iOS

## نظرة عامة
تم إعداد GitHub Actions لبناء تطبيق iOS (IPA) تلقائياً على سيرفرات macOS في GitHub.

## الملفات المضافة

### 1. `.github/workflows/ios-build.yml`
ملف workflow الذي يقوم بـ:
- بناء التطبيق على macOS
- تثبيت Flutter والتبعيات
- بناء iOS app
- إنشاء IPA file
- رفع الملفات كـ artifacts

### 2. `ios/exportOptions.plist`
ملف تكوين لتصدير IPA

## كيفية الاستخدام

### التشغيل التلقائي
سيتم تشغيل الـ workflow تلقائياً عند:
- Push إلى branch main أو master
- فتح Pull Request
- يمكن تشغيله يدوياً من تبويب Actions في GitHub

### التشغيل اليدوي
1. اذهب إلى repository على GitHub
2. انقر على تبويب "Actions"
3. اختر "Build iOS IPA" من القائمة اليسرى
4. انقر على "Run workflow"
5. اختر الـ branch واضغط "Run workflow"

### تحميل الملف المبني
بعد انتهاء الـ build بنجاح:
1. اذهب إلى تبويب "Actions"
2. انقر على الـ workflow run
3. في قسم "Artifacts" ستجد:
   - `iptv-turkey-ios`: يحتوي على IPA file
   - `ios-build-output`: ملفات البناء الكاملة

## للبناء بتوقيع Code Signing

لبناء IPA موقع ومستعد للنشر، تحتاج إلى:

### 1. إضافة Secrets في GitHub
اذهب إلى Settings → Secrets and variables → Actions وأضف:

- `IOS_CERTIFICATE_BASE64`: شهادة التوقيع بصيغة base64
- `IOS_CERTIFICATE_PASSWORD`: كلمة مرور الشهادة
- `IOS_PROVISION_PROFILE_BASE64`: Provisioning profile بصيغة base64
- `APPLE_ID`: Apple ID للحساب
- `APPLE_APP_SPECIFIC_PASSWORD`: App-specific password

### 2. تحديث exportOptions.plist
عدل الملف `ios/exportOptions.plist`:
```xml
<key>method</key>
<string>app-store</string>  <!-- أو adhoc أو enterprise -->
<key>teamID</key>
<string>YOUR_TEAM_ID</string>  <!-- ضع Team ID الخاص بك -->
```

### 3. استخدام workflow محسن
يمكن تحديث الـ workflow لإضافة خطوات Code Signing.

## ملاحظات مهمة

- ⚠️ **النسخة الحالية**: تبني app بدون code signing (للاختبار فقط)
- ⏱️ **المدة**: البناء يستغرق حوالي 10-15 دقيقة
- 💰 **التكلفة**: GitHub Actions مجاني لـ public repos، للـ private repos هناك حد مجاني شهري
- 📦 **الحجم**: GitHub يحتفظ بالـ artifacts لمدة 30 يوم

## حل المشاكل

### إذا فشل البناء
1. راجع logs في تبويب Actions
2. تحقق من `pubspec.yaml` و dependencies
3. تأكد من صحة `ios/Runner.xcworkspace`

### للحصول على معلومات أكثر
راجع [GitHub Actions Documentation](https://docs.github.com/en/actions)

## تثبيت التطبيق على iPhone

بعد بناء IPA، هناك عدة طرق لتثبيته على iPhone:

### الطريقة 1: TestFlight (الأفضل والأسهل) ⭐
**المتطلبات:**
- حساب Apple Developer ($99/سنة)
- رفع التطبيق على App Store Connect

**الخطوات:**
1. ارفع IPA إلى App Store Connect
2. اختر TestFlight من القائمة
3. أضف المختبرين (Internal/External Testers)
4. المختبرين يحملون TestFlight من App Store
5. يستلمون دعوة ويثبتون التطبيق

**المميزات:**
- ✅ سهل وآمن
- ✅ يدعم حتى 10,000 مختبر خارجي
- ✅ تحديثات تلقائية
- ✅ لا يتطلب UDID

### الطريقة 2: Xcode (مباشر من Mac)
**المتطلبات:**
- جهاز Mac
- كابل USB
- Xcode مثبت

**الخطوات:**
1. افتح Xcode
2. اذهب إلى Window → Devices and Simulators
3. وصل iPhone بكابل USB
4. اسحب IPA واسقطه على الجهاز
5. أو انقر على "+" واختر IPA

### الطريقة 3: AltStore (بدون حساب Developer)
**المتطلبات:**
- Windows أو Mac
- iTunes مثبت
- AltServer مثبت
- كابل USB

**الخطوات:**
1. حمل AltStore من [altstore.io](https://altstore.io)
2. ثبت AltServer على الكمبيوتر
3. وصل iPhone بكابل USB
4. شغل AltServer → Install AltStore على iPhone
5. ثق بالتطبيق: Settings → General → VPN & Device Management
6. انقل IPA للـ iPhone عبر AirDrop أو Files
7. افتح IPA بواسطة AltStore

**ملاحظات:**
- ⚠️ يجب تجديد التوقيع كل 7 أيام
- ⚠️ محدود بـ 3 تطبيقات فقط
- ✅ مجاني بالكامل

### الطريقة 4: Cydia Impactor
**المتطلبات:**
- Cydia Impactor
- Apple ID
- كابل USB

**الخطوات:**
1. حمل Cydia Impactor
2. وصل iPhone بكابل USB
3. اسحب IPA إلى Impactor
4. أدخل Apple ID وكلمة المرور
5. انتظر التثبيت

**ملاحظات:**
- ⚠️ قد لا يعمل مع إصدارات iOS الحديثة
- ⚠️ يحتاج App-Specific Password

### الطريقة 5: Diawi (شارك عبر رابط)
**المتطلبات:**
- حساب على [Diawi.com](https://diawi.com)
- IPA موقع

**الخطوات:**
1. اذهب إلى diawi.com
2. ارفع IPA
3. احصل على رابط
4. افتح الرابط من Safari على iPhone
5. انقر Install

**ملاحظات:**
- ⚠️ يحتاج IPA موقع بـ Ad Hoc أو Enterprise
- ✅ مناسب لتوزيع للمختبرين
- ⚠️ محدود بحجم الملف

### الطريقة 6: iOS App Signer + Sideloadly
**للتطبيقات بدون توقيع:**

**الخطوات:**
1. حمل Sideloadly من [sideloadly.io](https://sideloadly.io)
2. وصل iPhone بكابل USB
3. افتح Sideloadly واختر IPA
4. أدخل Apple ID
5. انقر Start

### الطريقة 7: إعداد Ad Hoc Distribution
**لتوزيع لأجهزة محددة:**

**الخطوات:**
1. سجل UDIDs الأجهزة في Apple Developer
2. أنشئ Ad Hoc Provisioning Profile
3. ابنِ IPA موقع بـ Ad Hoc
4. وزع IPA عبر Diawi أو رابط مباشر
5. المستخدمون يثبتون من Safari

## التوقيع Code Signing

### للحصول على IPA موقع:

#### 1. احصل على شهادة التوقيع
```bash
# على Mac
security find-identity -v -p codesigning
```

#### 2. أنشئ Provisioning Profile
- اذهب إلى [Apple Developer](https://developer.apple.com)
- Certificates, Identifiers & Profiles
- Profiles → + (Create New)
- اختر نوع التوزيع (Development/Ad Hoc/App Store)

#### 3. حدث workflow في GitHub
أضف secrets في GitHub:
```yaml
IOS_CERTIFICATE_BASE64
IOS_CERTIFICATE_PASSWORD
IOS_PROVISION_PROFILE_BASE64
```

## نصائح مهمة

### للاستخدام الشخصي:
- استخدم AltStore (مجاني)
- أو Xcode مباشرة

### للمختبرين:
- استخدم TestFlight (الأفضل)
- أو Ad Hoc + Diawi

### للإصدار النهائي:
- App Store فقط

### تجنب:
- ❌ تطبيقات "تثبيت IPA" غير موثوقة
- ❌ مواقع third-party غير معروفة
- ❌ Jailbreak إذا لم تكن محترف

## حل مشاكل التثبيت

### "Untrusted Enterprise Developer"
Settings → General → VPN & Device Management → Trust Developer

### "Unable to Install"
- تحقق من صلاحية Provisioning Profile
- تأكد من UDID مسجل (Ad Hoc)
- امسح app القديم قبل التثبيت

### "Could not verify app"
- تحتاج اتصال إنترنت عند أول فتح
- أو App Signing منتهي الصلاحية

## طرق إضافية لتثبيت IPA

### الطريقة 8: 3uTools (أداة شاملة)
**المتطلبات:**
- Windows فقط
- كابل USB
- 3uTools مثبت

**الخطوات:**
1. حمل 3uTools من الموقع الرسمي
2. ثبت البرنامج وشغله
3. وصل iPhone بكابل USB
4. انتقل إلى تبويب "Applications"
5. انقر على "Import & Install" أو اسحب IPA
6. اختر IPA واضغط Install

**المميزات:**
- ✅ واجهة سهلة جداً
- ✅ أدوات إضافية لإدارة الجهاز
- ✅ نسخ احتياطي واستعادة
- ✅ إدارة الملفات

**العيوب:**
- ⚠️ Windows فقط
- ⚠️ يحتاج توقيع صالح على IPA

### الطريقة 9: iMazing (احترافي)
**المتطلبات:**
- Windows أو Mac
- iMazing مثبت (مدفوع)
- كابل USB

**الخطوات:**
1. حمل iMazing (يوجد نسخة تجريبية)
2. وصل iPhone بكابل USB
3. اختر الجهاز من iMazing
4. انقر على "Manage Apps"
5. انقر على "Device" → Install .IPA
6. اختر ملف IPA

**المميزات:**
- ✅ موثوق واحترافي
- ✅ يعمل على Windows و Mac
- ✅ أدوات إدارة شاملة
- ✅ نسخ احتياطي متقدم

**العيوب:**
- ⚠️ مدفوع ($45 تقريباً)
- ⚠️ النسخة المجانية محدودة

### الطريقة 10: Apple Configurator 2 (Mac فقط)
**المتطلبات:**
- جهاز Mac
- Apple Configurator 2 من Mac App Store
- كابل USB

**الخطوات:**
1. حمل Apple Configurator 2 من Mac App Store
2. وصل iPhone بكابل USB
3. اختر الجهاز في Apple Configurator
4. اضغط على "Add" → Apps
5. اختر IPA من الكمبيوتر
6. وافق على التثبيت

**المميزات:**
- ✅ أداة رسمية من Apple
- ✅ مجانية بالكامل
- ✅ آمنة جداً
- ✅ مناسبة للتوزيع المؤسسي

**العيوب:**
- ⚠️ Mac فقط
- ⚠️ واجهة معقدة قليلاً

### الطريقة 11: Rickpactor (بديل Cydia Impactor)
**المتطلبات:**
- Windows أو Mac
- Apple ID
- كابل USB

**الخطوات:**
1. حمل Rickpactor
2. وصل iPhone بكابل USB
3. اسحب IPA إلى البرنامج
4. أدخل Apple ID
5. انتظر التثبيت

**المميزات:**
- ✅ بديل حديث لـ Cydia Impactor
- ✅ يعمل مع iOS الحديث
- ✅ مجاني

**العيوب:**
- ⚠️ يجدد كل 7 أيام (حساب مجاني)

### الطريقة 12: iOS App Installer (عبر Web Server)
**إعداد Web Server محلي:**

**الخطوات:**
1. أنشئ ملف `manifest.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>assets</key>
            <array>
                <dict>
                    <key>kind</key>
                    <string>software-package</string>
                    <key>url</key>
                    <string>https://yourserver.com/app.ipa</string>
                </dict>
            </array>
            <key>metadata</key>
            <dict>
                <key>bundle-identifier</key>
                <string>com.yourapp.id</string>
                <key>bundle-version</key>
                <string>1.0</string>
                <key>kind</key>
                <string>software</string>
                <key>title</key>
                <string>Your App Name</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>
```

2. ارفع IPA و manifest.plist على server بـ HTTPS
3. أنشئ صفحة HTML:
```html
<a href="itms-services://?action=download-manifest&url=https://yourserver.com/manifest.plist">
    Install App
</a>
```

4. افتح الرابط من Safari على iPhone

**المميزات:**
- ✅ توزيع مباشر عبر رابط
- ✅ مناسب للشركات
- ✅ لا يحتاج كابل USB

**العيوب:**
- ⚠️ يحتاج HTTPS server
- ⚠️ يحتاج IPA موقع

### الطريقة 13: AppCake / TweakBox (غير رسمي)
**⚠️ تحذير: هذه طرق غير رسمية**

**الخطوات:**
1. افتح Safari على iPhone
2. اذهب إلى موقع AppCake أو TweakBox
3. ثبت ملف التعريف
4. ثق بالملف من Settings
5. ابحث عن التطبيق وثبته

**ملاحظات:**
- ⚠️ غير آمن - قد يحتوي على malware
- ⚠️ قد يتوقف عن العمل بأي وقت
- ⚠️ ينتهك سياسات Apple
- ❌ غير موصى به

### الطريقة 14: Unc0ver / Checkra1n (Jailbreak)
**للأجهزة المعدلة فقط:**

**الخطوات:**
1. عمل Jailbreak للجهاز
2. ثبت AppSync Unified من Cydia
3. استخدم Filza أو أي مدير ملفات
4. افتح IPA مباشرة

**المميزات:**
- ✅ لا يحتاج توقيع
- ✅ عدد غير محدود من التطبيقات

**العيوب:**
- ⚠️ يحتاج Jailbreak
- ⚠️ قد يفقد الضمان
- ⚠️ مشاكل أمنية محتملة

### الطريقة 15: Esign (مباشر على iPhone)
**الخطوات:**
1. حمل Esign على iPhone (عبر طرق third-party)
2. انقل IPA للجهاز عبر Files أو iCloud
3. افتح IPA بواسطة Esign
4. وقع التطبيق باستخدام Apple ID
5. ثبت التطبيق

**المميزات:**
- ✅ لا يحتاج كمبيوتر
- ✅ توقيع مباشر من الجهاز

**العيوب:**
- ⚠️ صعب التثبيت
- ⚠️ قد لا يعمل مع iOS الحديث

### الطريقة 16: SignTools Server (Self-hosted)
**إعداد server شخصي:**

**الخطوات:**
1. ثبت SignTools Server على VPS أو جهازك
```bash
git clone https://github.com/SignTools/SignTools
cd SignTools
docker-compose up -d
```

2. افتح الواجهة على المتصفح
3. سجل دخول بـ Apple ID
4. ارفع IPA
5. حمل IPA الموقع
6. ثبت على iPhone

**المميزات:**
- ✅ توقيع تلقائي كل 7 أيام
- ✅ عدة أجهزة في نفس الوقت
- ✅ لا يحتاج كمبيوتر بعد الإعداد

**العيوب:**
- ⚠️ يحتاج إعداد server
- ⚠️ معقد للمبتدئين

### الطريقة 17: Appdome (للتطبيقات المؤسسية)
**الخطوات:**
1. اذهب إلى [appdome.com](https://appdome.com)
2. ارفع IPA
3. أضف security features إذا أردت
4. وقع التطبيق
5. حمل IPA الموقع

**المميزات:**
- ✅ إضافة security features
- ✅ للشركات والمؤسسات

**العيوب:**
- ⚠️ مدفوع للاستخدام الكامل

### الطريقة 18: TestApp.io (للمختبرين)
**الخطوات:**
1. اذهب إلى [testapp.io](https://testapp.io)
2. أنشئ حساب
3. ارفع IPA
4. شارك رابط التثبيت مع المختبرين
5. المختبرين يفتحون الرابط من Safari

**المميزات:**
- ✅ سهل جداً
- ✅ analytics ومتابعة
- ✅ للتجريب والاختبار

**العيوب:**
- ⚠️ محدود في النسخة المجانية
- ⚠️ يحتاج IPA موقع

## مقارنة الطرق

| الطريقة | سهولة | تكلفة | توافق | توقيع تلقائي |
|---------|-------|-------|-------|--------------|
| TestFlight | ⭐⭐⭐⭐⭐ | $99/سنة | iOS جميع | ✅ |
| AltStore | ⭐⭐⭐⭐ | مجاني | iOS 12.2+ | ✅ |
| Sideloadly | ⭐⭐⭐⭐⭐ | مجاني | iOS 7+ | ❌ |
| 3uTools | ⭐⭐⭐⭐ | مجاني | iOS جميع | ❌ |
| iMazing | ⭐⭐⭐⭐⭐ | $45 | iOS جميع | ❌ |
| Xcode | ⭐⭐⭐ | مجاني | iOS جميع | ❌ |
| SignTools | ⭐⭐ | مجاني | iOS 7+ | ✅ |
| Diawi | ⭐⭐⭐⭐ | مجاني/مدفوع | iOS 8+ | ❌ |

## أفضل طريقة حسب الحالة

### للاستخدام اليومي الشخصي:
**🏆 AltStore + AltStore Patreon ($3/سنة)**
- تجديد تلقائي عبر WiFi
- سهل وبسيط

### للتوزيع والمختبرين:
**🏆 TestFlight**
- احترافي وآمن
- تجربة مستخدم ممتازة

### لمرة واحدة فقط:
**🏆 Sideloadly**
- أسرع طريقة
- لا يحتاج اشتراك

### للشركات:
**🏆 MDM + Enterprise Certificate**
- توزيع واسع النطاق
- إدارة مركزية

### بدون كمبيوتر:
**🏆 Esign أو SignTools Web**
- توقيع من الجهاز مباشرة

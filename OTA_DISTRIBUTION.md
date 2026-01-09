# توزيع التطبيق عبر رابط مباشر (OTA Distribution)

## الطريقة 1: استخدام Diawi (الأسهل والأسرع) ⭐

### خطوات سريعة:
1. اذهب إلى: https://www.diawi.com
2. اسحب ملف IPA إلى الصفحة
3. اختر الإعدادات:
   - ✅ Create link
   - ✅ Allow installing on devices
   - حدد تاريخ انتهاء الصلاحية (اختياري)
4. انقر **"Send"**
5. انتظر حتى ينتهي الرفع
6. احصل على **رابط التثبيت** مثل: `https://i.diawi.com/xyz123`
7. أرسل الرابط لأي شخص
8. يفتح الرابط من **Safari على iPhone**
9. ينقر **"Install"** ويتثبت التطبيق مباشرة

### المميزات:
- ✅ مجاني تماماً
- ✅ سريع (دقائق قليلة)
- ✅ لا يحتاج تسجيل
- ✅ يعمل مع iOS 8+
- ✅ رابط قصير وسهل المشاركة

### العيوب:
- ⚠️ الرابط ينتهي بعد فترة
- ⚠️ محدود بحجم 500 MB
- ⚠️ يحتاج IPA موقع بـ Ad Hoc أو Enterprise

---

## الطريقة 2: استخدام App Center (من Microsoft)

### الخطوات:
1. اذهب إلى: https://appcenter.ms
2. سجل دخول (مجاني)
3. أنشئ app جديد
4. اختر iOS
5. اذهب إلى **Distribute → Groups**
6. أنشئ مجموعة للمختبرين
7. ارفع IPA:
   - **Distribute → Releases → New Release**
   - اسحب IPA
   - اختر المجموعة
8. احصل على رابط التثبيت
9. شارك الرابط أو أرسل دعوات

### المميزات:
- ✅ مجاني لـ unlimited apps
- ✅ analytics ومتابعة
- ✅ إشعارات للمستخدمين عند التحديثات
- ✅ احترافي

---

## الطريقة 3: استخدام TestApp.io

### الخطوات:
1. اذهب إلى: https://testapp.io
2. سجل حساب (مجاني للبداية)
3. انقر **"Upload"**
4. اسحب ملف IPA
5. املأ معلومات التطبيق
6. انقر **"Upload"**
7. احصل على رابط المشاركة
8. أرسل الرابط للمختبرين

### المميزات:
- ✅ واجهة جميلة
- ✅ تقارير ومتابعة
- ✅ سهل الاستخدام

### العيوب:
- ⚠️ النسخة المجانية محدودة
- ⚠️ يحتاج اشتراك للمزايا الكاملة

---

## الطريقة 4: استخدام InstallOnAir

### الخطوات:
1. اذهب إلى: https://www.installonair.com
2. سجل حساب مجاني
3. ارفع IPA
4. احصل على رابط التثبيت
5. شارك الرابط

### المميزات:
- ✅ مجاني
- ✅ بسيط
- ✅ رابط مباشر

---

## الطريقة 5: استخدام GitHub Releases + Pages

### إعداد التوزيع الخاص بك (مجاني):

#### 1. رفع IPA على GitHub Releases:
```bash
# في repository الخاص بك
git tag v1.0.0
git push origin v1.0.0
```
ثم اذهب إلى Releases → Create new release → ارفع IPA

#### 2. إنشاء صفحة التثبيت:
استخدم الملفات الموجودة في `ios/distribution/`:
- `manifest.plist` - ملف التوزيع
- `install.html` - صفحة التثبيت

#### 3. تفعيل GitHub Pages:
```bash
# أنشئ branch للصفحات
git checkout -b gh-pages
git push origin gh-pages
```

في Settings → Pages → اختر `gh-pages` branch

#### 4. تحديث الروابط:
في `manifest.plist` عدل:
```xml
<key>url</key>
<string>https://YOUR_USERNAME.github.io/YOUR_REPO/iptv_turkey.ipa</string>
```

في `install.html` عدل:
```html
<a href="itms-services://?action=download-manifest&url=https://YOUR_USERNAME.github.io/YOUR_REPO/manifest.plist">
```

#### 5. رابط التثبيت النهائي:
```
https://YOUR_USERNAME.github.io/YOUR_REPO/install.html
```

### المميزات:
- ✅ مجاني 100%
- ✅ تحكم كامل
- ✅ رابط دائم
- ✅ صفحة مخصصة

---

## الطريقة 6: استخدام Firebase App Distribution

### الخطوات:
1. اذهب إلى: https://console.firebase.google.com
2. أنشئ مشروع جديد
3. اذهب إلى **App Distribution**
4. انقر **"Get Started"**
5. ارفع IPA
6. أضف emails المختبرين
7. أرسل دعوات

### المميزات:
- ✅ مجاني
- ✅ من Google
- ✅ موثوق
- ✅ تكامل مع Firebase

---

## الطريقة 7: إنشاء Server خاص (HTTPS)

### المتطلبات:
- Domain مع HTTPS (مثل من Cloudflare)
- استضافة (يمكن GitHub Pages أو Netlify)

### الملفات المطلوبة:
```
/
├── iptv_turkey.ipa          (ملف التطبيق)
├── manifest.plist           (ملف التوزيع)
├── install.html             (صفحة التثبيت)
├── icon-57.png             (أيقونة صغيرة)
└── icon-512.png            (أيقونة كبيرة)
```

### إعداد manifest.plist:
```xml
<key>url</key>
<string>https://yourdomain.com/iptv_turkey.ipa</string>
```

### رابط التثبيت:
```
https://yourdomain.com/install.html
```

---

## مقارنة الخدمات

| الخدمة | مجاني | سهولة | HTTPS | حجم ماكس | صلاحية الرابط |
|--------|------|-------|-------|----------|---------------|
| Diawi | ✅ | ⭐⭐⭐⭐⭐ | ✅ | 500 MB | محدودة |
| App Center | ✅ | ⭐⭐⭐⭐ | ✅ | غير محدود | دائم |
| TestApp.io | محدود | ⭐⭐⭐⭐⭐ | ✅ | حسب الخطة | دائم |
| InstallOnAir | ✅ | ⭐⭐⭐⭐ | ✅ | 100 MB | دائم |
| GitHub Pages | ✅ | ⭐⭐⭐ | ✅ | 100 MB | دائم |
| Firebase | ✅ | ⭐⭐⭐⭐ | ✅ | غير محدود | دائم |

---

## خطوات التثبيت للمستخدم النهائي

### من iPhone:
1. افتح **Safari** (مهم جداً!)
2. اذهب إلى الرابط المرسل
3. اضغط **"تثبيت"** أو **"Install"**
4. اضغط **"تثبيت"** في النافذة المنبثقة
5. انتظر حتى يظهر التطبيق على الشاشة الرئيسية
6. **مهم**: قبل فتح التطبيق:
   - اذهب إلى: **الإعدادات** → **عام** → **إدارة VPN والأجهزة**
   - اضغط على اسم المطور/الشركة
   - اضغط **"موثوق"** أو **"Trust"**
7. الآن افتح التطبيق

---

## حل المشاكل الشائعة

### "Unable to Download App"
- ✅ تأكد من فتح الرابط من Safari فقط
- ✅ تحقق من اتصال الإنترنت
- ✅ تأكد من أن IPA موقع بشكل صحيح

### "Untrusted Enterprise Developer"
- ✅ اتبع خطوة 6 أعلاه (Trust Developer)

### "Cannot connect to ..."
- ✅ تأكد من أن الـ server يستخدم HTTPS (وليس HTTP)
- ✅ تحقق من صحة الروابط في manifest.plist

### الرابط لا يعمل
- ✅ تأكد من أن ملف manifest.plist قابل للوصول
- ✅ تحقق من صحة XML في manifest.plist
- ✅ تأكد من أن bundle-identifier صحيح

---

## التوصيات

### للاستخدام السريع والمؤقت:
**🥇 Diawi** - الأسرع والأسهل، جاهز في دقائق

### للتوزيع الاحترافي:
**🥇 App Center** - مجاني وكامل المزايا

### للتحكم الكامل:
**🥇 GitHub Pages** - مجاني ورابط دائم

### للشركات:
**🥇 Firebase App Distribution** - موثوق ومتكامل

---

## أمثلة روابط جاهزة

### Diawi:
```
https://i.diawi.com/ABC123
```

### App Center:
```
https://install.appcenter.ms/orgs/YOUR_ORG/apps/iptv-turkey
```

### GitHub Pages:
```
https://yourusername.github.io/iptv-turkey/install.html
```

---

## ملاحظات أمنية مهمة

⚠️ **تحذير:**
- لا تحمل IPA على مواقع مشبوهة
- استخدم فقط خدمات موثوقة
- IPA يجب أن يكون موقع بشكل صحيح
- لا تشارك روابط التثبيت علناً إذا كان التطبيق خاص

---

## الخلاصة

**أسهل طريقة:**
1. ارفع IPA على **Diawi.com**
2. احصل على الرابط
3. أرسله لأي شخص
4. يفتح من Safari ويثبت مباشرة ✅

**لا تحتاج:**
- ❌ كمبيوتر
- ❌ كابل USB
- ❌ برامج إضافية
- ❌ Jailbreak

**تحتاج فقط:**
- ✅ IPA موقع
- ✅ Safari على iPhone
- ✅ اتصال إنترنت

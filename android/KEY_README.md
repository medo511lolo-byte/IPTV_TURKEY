# 🔐 ملف key.properties

هذا ملف حساس جداً يحتوي على معلومات التوقيع!

## ⚠️ تحذير مهم

**لا تشارك هذا الملف أبداً!**
- لا ترفعه على GitHub
- لا تشاركه عبر البريد الإلكتروني
- احفظه في مكان آمن

## 📝 كيفية إنشاء الملف

1. انسخ `key.properties.example` إلى `key.properties`
2. استبدل القيم بكلمات المرور الحقيقية
3. ضع ملف `key.jks` في مجلد `android/app/`

## 📄 محتوى الملف

```properties
storePassword=YOUR_ACTUAL_PASSWORD
keyPassword=YOUR_ACTUAL_PASSWORD
keyAlias=iptv-turkey
storeFile=key.jks
```

## 🔑 إنشاء مفتاح التوقيع

```bash
cd android/app
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias iptv-turkey
```

## 💾 Backup مهم!

احفظ نسخة من:
- `key.jks`
- كلمات المرور
- `key.properties`

**إذا فقدت المفتاح، لن تتمكن من تحديث التطبيق في المتجر!**

## 📋 Checklist

- [ ] تم إنشاء key.jks
- [ ] تم إنشاء key.properties
- [ ] تم حفظ backup
- [ ] تم إضافة إلى .gitignore
- [ ] تم اختبار البناء

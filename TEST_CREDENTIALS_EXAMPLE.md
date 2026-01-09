# 🔐 ملف بيانات الاختبار (مثال فقط)

## ⚠️ تحذير مهم
**لا تستخدم هذه البيانات الحقيقية في الكود!**
هذا ملف للتذكير فقط.

---

## 📝 بيانات تسجيل الدخول

### الصيغة العامة لـ Xtream Codes:

```
Server URL: http://example.com:8080
Username: your_username
Password: your_password
```

### مثال على الروابط:

**رابط API للقنوات المباشرة:**
```
http://server:port/player_api.php?username=USERNAME&password=PASSWORD&action=get_live_streams
```

**رابط تشغيل قناة:**
```
http://server:port/live/USERNAME/PASSWORD/STREAM_ID.ts
```

**رابط جلب المعلومات:**
```
http://server:port/player_api.php?username=USERNAME&password=PASSWORD&action=get_account_info
```

---

## 🧪 للاختبار

يمكنك استخدام خدمات IPTV تجريبية مجانية للاختبار:
- ابحث عن "free IPTV test" على الإنترنت
- بعض الخدمات تقدم فترات تجريبية مجانية
- يمكنك إنشاء خادم تجريبي خاص بك

---

## 📊 API Endpoints المدعومة

### معلومات الحساب
```
action=get_account_info
```

### القنوات المباشرة
```
action=get_live_streams
action=get_live_categories
```

### الأفلام
```
action=get_vod_streams
action=get_vod_categories
action=get_vod_info&vod_id=XXXX
```

### المسلسلات
```
action=get_series
action=get_series_categories
action=get_series_info&series_id=XXXX
```

### EPG (جدول البرامج)
```
action=get_simple_data_table&stream_id=XXXX
action=get_short_epg&stream_id=XXXX&limit=10
```

---

## 💡 نصائح

1. **احفظ بياناتك بأمان**:
   - لا تشاركها مع أحد
   - لا ترفعها على GitHub
   - استخدم `.env` files

2. **اختبر الروابط أولاً**:
   - جرب الروابط في المتصفح قبل البرمجة
   - استخدم VLC Player لاختبار القنوات

3. **الأمان**:
   - غيّر كلمة المرور بانتظام
   - استخدم HTTPS إن أمكن
   - لا تحفظ البيانات بصيغة plain text

---

## 🔒 كيفية حماية البيانات في التطبيق

### استخدام flutter_secure_storage:

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// حفظ
await storage.write(key: 'server', value: 'http://example.com');
await storage.write(key: 'username', value: 'user123');
await storage.write(key: 'password', value: 'pass123');

// قراءة
String? server = await storage.read(key: 'server');
String? username = await storage.read(key: 'username');
String? password = await storage.read(key: 'password');

// حذف
await storage.delete(key: 'password');
await storage.deleteAll();
```

---

## ⚙️ Environment Variables (متقدم)

### 1. أنشئ ملف `.env`:
```env
SERVER_URL=http://example.com:8080
USERNAME=your_username
PASSWORD=your_password
```

### 2. أضف إلى `.gitignore`:
```
.env
*.env
```

### 3. استخدم flutter_dotenv:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

// استخدام
String server = dotenv.env['SERVER_URL'] ?? '';
```

---

**تذكير**: هذا ملف تعليمي فقط. لا تضع بيانات حقيقية هنا!

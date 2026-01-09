import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/xtream_api.dart';

class SettingsScreen extends StatefulWidget {
  final String server, user, pass;

  const SettingsScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? expireDate;
  bool isLoadingExpire = true;

  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }

  Future<void> _loadAccountInfo() async {
    try {
      final info = await XtreamAPI.getAccountInfo(
        widget.server,
        widget.user,
        widget.pass,
      );

      String? expire;
      if (info.containsKey('exp_date')) {
        final expTimestamp = int.tryParse(info['exp_date']?.toString() ?? '0');
        if (expTimestamp != null && expTimestamp > 0) {
          final expDateTime = DateTime.fromMillisecondsSinceEpoch(expTimestamp * 1000);
          expire = DateFormat('yyyy-MM-dd', 'ar_SA').format(expDateTime);
        }
      }

      if (mounted) {
        setState(() {
          expireDate = expire ?? 'غير متاح';
          isLoadingExpire = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          expireDate = 'خطأ في التحميل';
          isLoadingExpire = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader('حسابي', Icons.account_circle),
          _buildCard([
            _buildListTile(
              icon: Icons.person,
              title: 'اسم المستخدم',
              subtitle: widget.user,
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.calendar_today,
              title: 'انتهاء الاشتراك',
              subtitle: isLoadingExpire ? 'جاري التحميل...' : (expireDate ?? 'غير متاح'),
              onTap: () {},
              trailing: isLoadingExpire 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              subtitle: 'الخروج من حسابك',
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              trailing: const Icon(Icons.exit_to_app, color: Colors.red),
            ),
          ]),

          const SizedBox(height: 24),

          // Player Settings
          _buildSectionHeader('المشغل', Icons.play_circle),
          _buildCard([
            _buildListTile(
              icon: Icons.video_settings,
              title: 'جودة الفيديو',
              subtitle: 'تلقائي',
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.speed,
              title: 'سرعة التشغيل',
              subtitle: '1.0x',
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.subtitles,
              title: 'الترجمة',
              subtitle: 'مفعلة',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // App Settings
          _buildSectionHeader('التطبيق', Icons.settings_applications),
          _buildCard([
            _buildListTile(
              icon: Icons.cached,
              title: 'مسح الذاكرة المؤقتة',
              subtitle: 'إزالة الملفات المؤقتة',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم مسح الذاكرة!')),
                );
              },
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.update,
              title: 'التحقق من التحديثات',
              subtitle: 'الإصدار 1.0.0',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('About', Icons.info),
          _buildCard([
            _buildListTile(
              icon: Icons.code,
              title: 'إصدار التطبيق',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.privacy_tip,
              title: 'سياسة الخصوصية',
              subtitle: 'اقرأ سياسة الخصوصية',
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.description,
              title: 'شروط الخدمة',
              subtitle: 'اقرأ الشروط والأحكام',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 40),

          // Footer
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.live_tv,
                  size: 48,
                  color: Colors.blue.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'IPTV IRAQ Player',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with TURKEY',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

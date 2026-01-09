import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  static const String fixedServer = 'http://tv.starnetcloud.online:8880';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  final user = TextEditingController();
  final pass = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController.forward();
    _slideController.forward();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (user.text.isEmpty || pass.text.isEmpty) {
      _showErrorSnackbar('الرجاء إدخال اسم المستخدم وكلمة المرور');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // حفظ بيانات تسجيل الدخول
      await _saveCredentials();
      
      // الانتقال مباشرة إلى Dashboard
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Dashboard(
              server: LoginScreen.fixedServer,
              user: user.text,
              pass: pass.text,
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('حدث خطأ: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_username', user.text);
      await prefs.setString('saved_password', pass.text);
    } catch (e) {
      // تجاهل الأخطاء عند الحفظ
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUser = prefs.getString('saved_username') ?? '';
      final savedPass = prefs.getString('saved_password') ?? '';
      
      if (mounted) {
        setState(() {
          user.text = savedUser;
          pass.text = savedPass;
        });
      }
    } catch (e) {
      // تجاهل الأخطاء عند التحميل
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.bgGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOut,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          child: const Icon(
                            Icons.live_tv,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          'IPTV IRAQ',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'تسجيل الدخول',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 48),

                        // Form
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.darkCard,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            children: [
                              // Username
                              TextField(
                                controller: user,
                                enabled: !_isLoading,
                                decoration: InputDecoration(
                                  labelText: 'اسم المستخدم',
                                  prefixIcon:
                                      const Icon(Icons.person_outlined),
                                  filled: true,
                                  fillColor: AppTheme.darkCard2,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password
                              TextField(
                                controller: pass,
                                enabled: !_isLoading,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon:
                                      const Icon(Icons.lock_outlined),
                                  filled: true,
                                  fillColor: AppTheme.darkCard2,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _login,
                                  icon: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Icon(Icons.login_rounded,
                                          size: 24),
                                  label: Text(
                                    _isLoading ? 'جاري تسجيل الدخول...' : 'دخول',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

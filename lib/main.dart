import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/iptv_provider.dart';
import 'screens/login.dart';
import 'theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => IPTVProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IPTV IRAQ',
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}

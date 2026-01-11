import 'package:flutter/material.dart';
import '../theme.dart';
import 'episodes.dart';

class SeriesDetailsScreen extends StatefulWidget {
  final String seriesId;
  final String seriesName;
  final String? poster;
  final String server;
  final String user;
  final String pass;

  const SeriesDetailsScreen({
    super.key,
    required this.seriesId,
    required this.seriesName,
    this.poster,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<SeriesDetailsScreen> createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الصورة
          Positioned.fill(
            child: widget.poster != null && widget.poster!.isNotEmpty
                ? Image.network(
                    widget.poster!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.darkCard2,
                    ),
                  )
                : Container(color: AppTheme.darkCard2),
          ),
          // تدرج سوداوي
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          // المحتوى
          SingleChildScrollView(
            child: Column(
              children: [
                // رأس الشاشة
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                // مساحة فارغة
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                // محتوى التفاصيل
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Text(
                        widget.seriesName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // معلومات إضافية
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Drama, Thriller',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, color: Color(0xFFFF6B35), size: 18),
                          const SizedBox(width: 4),
                          const Text(
                            '5',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // زر التشغيل
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EpisodesScreen(
                                  server: widget.server,
                                  user: widget.user,
                                  pass: widget.pass,
                                  seriesId: widget.seriesId,
                                  seriesName: widget.seriesName,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                          label: const Text(
                            'شغّل الآن',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // الوصف
                      const Text(
                        'Drama, Thriller, Mystery',
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'مسلسل درامي مثير حول قصة خيالية تتناول أحداثاً غامضة وتطورات مشوقة تأخذ المشاهد في رحلة مليئة بالتشويق والإثارة',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

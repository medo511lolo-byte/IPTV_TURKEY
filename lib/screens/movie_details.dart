import 'package:flutter/material.dart';
import '../theme.dart';
import 'movies_player.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String movieId;
  final String movieName;
  final String? poster;
  final String? containerExtension;
  final String server;
  final String user;
  final String pass;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    required this.movieName,
    this.poster,
    this.containerExtension,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
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
                        widget.movieName,
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
                              'Fantasy, Action',
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
                            final ext = widget.containerExtension?.isNotEmpty == true
                                ? widget.containerExtension
                                : 'mp4';
                            final url =
                                "${widget.server}/movie/${widget.user}/${widget.pass}/${widget.movieId}.$ext";
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MoviesPlayerScreen(
                                  url: url,
                                  movieName: widget.movieName,
                                  poster: widget.poster,
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
                        'Fantasy, Action, Adventure',
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'بعدما يشهر عمل آخر خطة الدمار في أحياء موطنهم تنطلق "الولايات" و"أندراس" والفيلسوف "كريس" في أخطر مهمة يخوضونها في حياتهم',
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

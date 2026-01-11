import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../services/watch_history_service.dart';
import '../theme.dart';
import 'player.dart';
import 'episodes.dart';

class HomeScreen extends StatefulWidget {
  final String server, user, pass;

  const HomeScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IPTVProvider>().loadMovies(widget.server, widget.user, widget.pass);
        context.read<IPTVProvider>().loadSeries(widget.server, widget.user, widget.pass);
      }
    });
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final history = await WatchHistoryService.getHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  String _getTimeAgo(int timestamp) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'live':
        return Icons.tv;
      case 'movie':
        return Icons.movie;
      case 'series':
        return Icons.theaters;
      default:
        return Icons.play_circle;
    }
  }

  void _playItem(Map<String, dynamic> item) {
    final type = item['type'] as String;
    
    if (type == 'series') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EpisodesScreen(
            server: widget.server,
            user: widget.user,
            pass: widget.pass,
            seriesId: item['id'],
            seriesName: item['name'],
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlayerScreen(
            url: item['url'],
            channelName: item['name'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IPTVProvider>(
        builder: (context, iptv, _) {
          final movies = (iptv.moviesData['movies'] as List?) ?? [];
          final series = (iptv.seriesData['series'] as List?) ?? [];

          if (_isLoading) {
            return const Center(
              child: SpinKitFadingCircle(
                color: AppTheme.primaryBlue,
                size: 50.0,
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // اقلام شاخت مؤخرا
              _buildSectionHeader('اقلام شاخت مؤخرا'),
              _buildHorizontalScroll(_history.isEmpty ? movies : _history),
              const SizedBox(height: 24),
              // مسلسلات مضافة حديثا
              _buildSectionHeader('مسلسلات مضافة حديثا'),
              _buildHorizontalScroll(series.take(10).toList()),
              const SizedBox(height: 24),
              // الأفلام المضافة حديثا
              _buildSectionHeader('الأفلام المضافة حديثا'),
              _buildHorizontalScroll(movies.take(10).toList()),
              const SizedBox(height: 24),
              // جميع الأفلام
              _buildSectionHeader('جميع الأفلام'),
              _buildGridView(movies),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalScroll(List items) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length > 8 ? 8 : items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final poster = item['poster'] ?? item['stream_icon'] ?? '';
          final title = item['name'] ?? item['title'] ?? 'Unknown';

          return GestureDetector(
            onTap: () => _playItem(item),
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    poster.isNotEmpty
                        ? Image.network(
                            poster,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppTheme.darkCard,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : Container(
                            color: AppTheme.darkCard,
                            child: const Icon(Icons.image_not_supported),
                          ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List items) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final poster = item['poster'] ?? '';
        final title = item['name'] ?? 'Unknown';

        return GestureDetector(
          onTap: () => _playItem(item),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                poster.isNotEmpty
                    ? Image.network(
                        poster,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppTheme.darkCard,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      )
                    : Container(
                        color: AppTheme.darkCard,
                        child: const Icon(Icons.image_not_supported),
                      ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

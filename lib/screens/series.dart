import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'series_grid.dart';

class SeriesScreen extends StatefulWidget {
  final String server, user, pass;

  const SeriesScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  final String _selectedCategory = 'all';
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IPTVProvider>().loadSeries(widget.server, widget.user, widget.pass);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المسلسلات',
          style: TextStyle(
            color: Color(0xFFFF6B35),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFFF6B35), size: 28),
            onPressed: () {
              context.read<IPTVProvider>().loadSeries(widget.server, widget.user, widget.pass);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFF6B35), size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<IPTVProvider>(
        builder: (context, iptv, _) {
          if (iptv.isLoadingSeries) {
            return const Center(
              child: SpinKitFadingCircle(
                color: AppTheme.primaryBlue,
                size: 50.0,
              ),
            );
          }

          if (iptv.seriesData.isEmpty) {
            return const Center(child: Text("No series available"));
          }

          final categories = (iptv.seriesData['categories'] as List?) ?? [];
          final series = (iptv.seriesData['series'] as List?) ?? [];

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final total = series.length;
                return _buildCategoryTile(
                  title: 'جميع المسلسلات',
                  count: total,
                  trailingIcon: Icons.theaters,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeriesGridScreen(
                          categoryId: 'all',
                          categoryName: 'جميع المسلسلات',
                          server: widget.server,
                          user: widget.user,
                          pass: widget.pass,
                        ),
                      ),
                    );
                  },
                );
              }

              final cat = categories[index - 1];
              final id = cat['category_id']?.toString() ?? '';
              final name = cat['category_name']?.toString() ?? 'قسم';
              final count = series.where((s) => s['category_id']?.toString() == id).length;

              return _buildCategoryTile(
                title: name,
                count: count,
                trailingIcon: Icons.live_tv,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeriesGridScreen(
                        categoryId: id,
                        categoryName: name,
                        server: widget.server,
                        user: widget.user,
                        pass: widget.pass,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

Widget _buildCategoryTile({
    required String title,
    required int count,
    required IconData trailingIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_left, color: Colors.white54, size: 22),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$count',
                    style: const TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(trailingIcon, color: Colors.white60, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

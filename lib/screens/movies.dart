import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'movies_grid.dart';

class MoviesScreen extends StatefulWidget {
  final String server, user, pass;

  const MoviesScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final String _selectedCategory = 'all';
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IPTVProvider>().loadMovies(widget.server, widget.user, widget.pass);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأفلام',
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
              context.read<IPTVProvider>().loadMovies(widget.server, widget.user, widget.pass);
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
          if (iptv.isLoadingMovies) {
            return const Center(
              child: SpinKitFadingCircle(
                color: AppTheme.primaryBlue,
                size: 50.0,
              ),
            );
          }

          if (iptv.moviesData.isEmpty) {
            return const Center(child: Text("No movies available"));
          }

          final categories = (iptv.moviesData['categories'] as List?) ?? [];
          final movies = (iptv.moviesData['movies'] as List?) ?? [];

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final total = movies.length;
                return _buildCategoryTile(
                  title: 'جميع الأفلام',
                  count: total,
                  trailingIcon: Icons.movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoviesGridScreen(
                          categoryId: 'all',
                          categoryName: 'جميع الأفلام',
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
              final count = movies.where((m) => m['category_id']?.toString() == id).length;

              return _buildCategoryTile(
                title: name,
                count: count,
                trailingIcon: Icons.movie_creation,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoviesGridScreen(
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

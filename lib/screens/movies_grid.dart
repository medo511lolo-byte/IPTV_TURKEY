import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'movie_details.dart';

class MoviesGridScreen extends StatefulWidget {
  final String server, user, pass;
  final String categoryId;
  final String categoryName;

  const MoviesGridScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<MoviesGridScreen> createState() => _MoviesGridScreenState();
}

class _MoviesGridScreenState extends State<MoviesGridScreen> {
  String _searchQuery = '';
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_showSearch
            ? Text(
                widget.categoryName,
                style: const TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'بحث...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search, color: Color(0xFFFF6B35)),
            onPressed: () {
              setState(() {
                if (_showSearch) {
                  _searchQuery = '';
                  _searchController.clear();
                }
                _showSearch = !_showSearch;
              });
            },
          ),
          const SizedBox(width: 8),
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

          final movies = (iptv.moviesData['movies'] as List?) ?? [];

          // تصفية حسب الفئة
          final filtered = widget.categoryId == 'all'
              ? movies
              : movies
                  .where((m) => m['category_id']?.toString() == widget.categoryId)
                  .toList();

          // تطبيق البحث
          final searchFiltered = _searchQuery.isEmpty
              ? filtered
              : filtered
                  .where((m) => (m['name']?.toString() ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
                  .toList();

          if (searchFiltered.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isNotEmpty ? 'لم يتم العثور على أفلام' : 'لا توجد أفلام في هذا القسم',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: searchFiltered.length,
            itemBuilder: (context, index) {
              final movie = searchFiltered[index];
              final movieId = movie['stream_id']?.toString() ?? '';
              final movieName = movie['name'] ?? 'Unknown';
              final poster = movie['stream_icon'];
              final containerExt = movie['container_extension']?.toString();

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsScreen(
                        movieId: movieId,
                        movieName: movieName,
                        poster: poster,
                        containerExtension: containerExt,
                        server: widget.server,
                        user: widget.user,
                        pass: widget.pass,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: poster != null && poster.isNotEmpty
                              ? Image.network(
                                  poster,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppTheme.darkCard2,
                                    child: const Icon(
                                      Icons.movie,
                                      color: Colors.white30,
                                      size: 40,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: AppTheme.darkCard2,
                                  child: const Icon(
                                    Icons.movie,
                                    color: Colors.white30,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          movieName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

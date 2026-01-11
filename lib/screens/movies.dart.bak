import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'player.dart';

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
  bool _isGridView = true;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchQuery.isEmpty
            ? const Text("Movies")
            : TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
        automaticallyImplyLeading: false,
        actions: [
          if (_searchQuery.isEmpty)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _searchQuery = ' ';
                });
              },
              tooltip: 'Search',
            ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List View' : 'Grid View',
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

          final categories = (iptv.moviesData['categories'] as List?) ?? [];
          final movies = (iptv.moviesData['movies'] as List?) ?? [];

          final filtered = _selectedCategory == 'all'
              ? movies
              : movies
                  .where((m) => m['category_id']?.toString() == _selectedCategory)
                  .toList();

          // تطبيق البحث
          final searchFiltered = _searchQuery.isEmpty
              ? filtered
              : filtered
                  .where((m) => (m['name']?.toString() ?? '').toLowerCase().contains(_searchQuery))
                  .toList();

          return Column(
            children: [
              _buildCategoryBar(categories),
              Expanded(
                child: _isGridView
                    ? _buildGridView(searchFiltered)
                    : _buildListView(searchFiltered),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryBar(List categories) {
    final items = [
      {'category_id': 'all', 'category_name': 'All'},
      ...categories,
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = items[i];
          final id = cat['category_id']?.toString() ?? 'all';
          final name = cat['category_name']?.toString() ?? 'All';
          final selected = id == _selectedCategory;

          return FilterChip(
            selected: selected,
            label: Text(name),
            onSelected: (isSelected) {
              setState(() {
                _selectedCategory = id;
              });
            },
            backgroundColor: AppTheme.darkCard,
            selectedColor: AppTheme.primaryBlue,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (_, i) {
        final movie = movies[i];
        final streamId = movie['stream_id']?.toString() ?? '';
        final movieName = movie['name'] ?? 'Unknown';
        final poster = movie['stream_icon'];
        final extension = movie['container_extension'] ?? 'mp4';

        return Focus(
          child: InkWell(
            onTap: () {
              final url = "${widget.server}/movie/${widget.user}/${widget.pass}/$streamId.$extension";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerScreen(
                    url: url,
                    channelName: movieName,
                    itemId: streamId,
                    itemType: 'movie',
                    poster: poster,
                  ),
                ),
              );
            },
            focusColor: const Color(0xFF2563EB).withValues(alpha: 0.3),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  poster != null && poster.isNotEmpty
                      ? Image.network(
                          poster,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppTheme.darkCard2,
                            child: const Icon(
                              Icons.movie,
                              size: 50,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        )
                      : Container(
                          color: AppTheme.darkCard2,
                          child: const Icon(
                            Icons.movie,
                            size: 50,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                      child: Text(
                        movieName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List movies) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final streamId = movie['stream_id']?.toString() ?? '';
        final movieName = movie['name'] ?? 'Unknown';
        final poster = movie['stream_icon'];
        final extension = movie['container_extension'] ?? 'mp4';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: poster != null && poster.isNotEmpty
                ? Image.network(
                    poster,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.movie),
                  )
                : const Icon(Icons.movie),
            title: Text(movieName),
            trailing: const Icon(Icons.play_arrow, color: AppTheme.primaryBlue),
            onTap: () {
              final url = "${widget.server}/movie/${widget.user}/${widget.pass}/$streamId.$extension";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerScreen(
                    url: url,
                    channelName: movieName,
                    itemId: streamId,
                    itemType: 'movie',
                    poster: poster,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

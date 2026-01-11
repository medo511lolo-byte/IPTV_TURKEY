import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'series_details.dart';

class SeriesGridScreen extends StatefulWidget {
  final String server, user, pass;
  final String categoryId;
  final String categoryName;

  const SeriesGridScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<SeriesGridScreen> createState() => _SeriesGridScreenState();
}

class _SeriesGridScreenState extends State<SeriesGridScreen> {
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

          final series = (iptv.seriesData['series'] as List?) ?? [];

          // تصفية حسب الفئة
          final filtered = widget.categoryId == 'all'
              ? series
              : series
                  .where((s) => s['category_id']?.toString() == widget.categoryId)
                  .toList();

          // تطبيق البحث
          final searchFiltered = _searchQuery.isEmpty
              ? filtered
              : filtered
                  .where((s) => (s['name']?.toString() ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
                  .toList();

          if (searchFiltered.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isNotEmpty ? 'لم يتم العثور على مسلسلات' : 'لا توجد مسلسلات في هذا القسم',
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
              final seriesItem = searchFiltered[index];
              final seriesId = seriesItem['series_id']?.toString() ?? '';
              final seriesName = seriesItem['name'] ?? 'Unknown';
              final poster = seriesItem['cover'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeriesDetailsScreen(
                        seriesId: seriesId,
                        seriesName: seriesName,
                        poster: poster,
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
                                      Icons.theaters,
                                      color: Colors.white30,
                                      size: 40,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: AppTheme.darkCard2,
                                  child: const Icon(
                                    Icons.theaters,
                                    color: Colors.white30,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          seriesName,
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

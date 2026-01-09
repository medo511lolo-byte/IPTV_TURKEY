import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'episodes.dart';

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
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchQuery.isEmpty
            ? const Text("Series")
            : TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search series...',
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
        centerTitle: true,
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
          
          final categories = (iptv.seriesData['categories'] as List?) ?? [];
          final series = (iptv.seriesData['series'] as List?) ?? [];

          final filtered = _selectedCategory == 'all'
              ? series
              : series
                  .where((s) => s['category_id']?.toString() == _selectedCategory)
                  .toList();

          // تطبيق البحث
          final searchFiltered = _searchQuery.isEmpty
              ? filtered
              : filtered
                  .where((s) => (s['name']?.toString() ?? '').toLowerCase().contains(_searchQuery))
                  .toList();

          return Column(
            children: [
              _buildCategoryBar(categories),
              Expanded(
                child: _buildSeriesList(searchFiltered),
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

  Widget _buildSeriesList(List series) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final s = series[index];
        final streamId = s['series_id']?.toString() ?? s['stream_id']?.toString() ?? '';
        final seriesName = s['name'] ?? 'Unknown';
        final poster = s['cover'] ?? s['stream_icon'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: poster != null && poster.isNotEmpty
                ? Image.network(
                    poster,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.theaters),
                  )
                : const Icon(Icons.theaters),
            title: Text(seriesName),
            trailing: const Icon(Icons.arrow_forward, color: AppTheme.primaryBlue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EpisodesScreen(
                    server: widget.server,
                    user: widget.user,
                    pass: widget.pass,
                    seriesId: streamId,
                    seriesName: seriesName,
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

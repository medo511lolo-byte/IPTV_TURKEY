import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'player.dart';
import 'epg_screen.dart';

class LiveTVScreen extends StatefulWidget {
  final String server, user, pass;

  const LiveTVScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<LiveTVScreen> createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  bool _isGridView = true;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IPTVProvider>().loadLive(widget.server, widget.user, widget.pass);
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
            ? const Text("Live TV")
            : TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search channels...',
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<IPTVProvider>().refreshLive(widget.server, widget.user, widget.pass);
            },
            tooltip: 'Refresh',
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
          if (iptv.isLoadingLive) {
            return const Center(
              child: SpinKitFadingCircle(
                color: AppTheme.primaryBlue,
                size: 50.0,
              ),
            );
          }

          if (iptv.liveData.isEmpty) {
            return const Center(child: Text("No channels available"));
          }

          final categories = (iptv.liveData['categories'] as List?) ?? [];
          final channels = (iptv.liveData['channels'] as List?) ?? [];

          final filtered = _selectedCategory == 'all'
              ? channels
              : channels
                  .where((c) => c['category_id']?.toString() == _selectedCategory)
                  .toList();

          // تطبيق البحث
          final searchFiltered = _searchQuery.isEmpty
              ? filtered
              : filtered
                  .where((c) => (c['name']?.toString() ?? '').toLowerCase().contains(_searchQuery))
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

  Widget _buildGridView(List channels) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: channels.length,
      itemBuilder: (_, i) {
        final channel = channels[i];
        final streamId = channel['stream_id']?.toString() ?? '';
        final channelName = channel['name'] ?? 'Unknown';
        final icon = channel['stream_icon'];
        final tvArchive = channel['tv_archive'];
        final supportsCatchup = tvArchive == 1 || tvArchive == '1';

        return Focus(
          child: InkWell(
            onTap: () {
              final url = "${widget.server}/live/${widget.user}/${widget.pass}/$streamId.m3u8";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerScreen(
                    url: url,
                    channelName: channelName,
                    itemId: streamId,
                    itemType: 'live',
                    poster: icon,
                  ),
                ),
              );
            },
            onLongPress: () {
              final archiveDays = int.tryParse(
                    channel['tv_archive_duration']?.toString() ?? '0'
                  ) ?? 0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EPGScreen(
                    server: widget.server,
                    user: widget.user,
                    pass: widget.pass,
                    streamId: streamId,
                    channelName: channelName,
                    supportsCatchup: supportsCatchup,
                    archiveDays: archiveDays,
                  ),
                ),
              );
            },
            focusColor: const Color(0xFF2563EB).withValues(alpha: 0.3),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: icon != null && icon.isNotEmpty
                              ? Image.network(
                                  icon,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.tv,
                                    size: 40,
                                    color: Color(0xFF2563EB),
                                  ),
                                )
                              : const Icon(
                                  Icons.tv,
                                  size: 40,
                                  color: Color(0xFF2563EB),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          channelName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (supportsCatchup)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'EPG',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildListView(List channels) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        final streamId = channel['stream_id']?.toString() ?? '';
        final channelName = channel['name'] ?? 'Unknown';
        final icon = channel['stream_icon'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: icon != null && icon.isNotEmpty
                ? Image.network(
                    icon,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.tv),
                  )
                : const Icon(Icons.tv),
            title: Text(channelName),
            onTap: () {
              final url = "${widget.server}/live/${widget.user}/${widget.pass}/$streamId.ts";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerScreen(
                    url: url,
                    channelName: channelName,
                    itemId: streamId,
                    itemType: 'live',
                    poster: icon,
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

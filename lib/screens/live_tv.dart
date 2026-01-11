import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import '../theme.dart';
import 'player.dart';

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
  final String _selectedCategory = 'all';
  final String _searchQuery = '';
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
        title: const Text(
          'بث مباشر',
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
              context.read<IPTVProvider>().loadLive(widget.server, widget.user, widget.pass);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFF6B35), size: 28),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ChannelSearchDelegate(
                  context.read<IPTVProvider>(),
                  widget.server,
                  widget.user,
                  widget.pass,
                ),
              );
            },
          ),
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

          // شاشة الأقسام أولاً كما في التصميم المرفق
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: categories.length + 1, // +1 لبند "جميع القنوات"
            itemBuilder: (context, index) {
              if (index == 0) {
                // جميع القنوات
                final total = channels.length;
                return _buildCategoryTile(
                  title: 'جميع القنوات',
                  count: total,
                  trailingIcon: Icons.view_list,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerScreen(
                          // بدون رابط ابتدائي؛ نمرر الفئة "all" لإظهار قائمة كل القنوات
                          categoryId: 'all',
                          server: widget.server,
                          user: widget.user,
                          pass: widget.pass,
                          channelName: 'اختر قناة',
                        ),
                      ),
                    );
                  },
                );
              }

              final cat = categories[index - 1];
              final id = cat['category_id']?.toString() ?? '';
              final name = cat['category_name']?.toString() ?? 'قسم';
              final count = channels
                  .where((c) => c['category_id']?.toString() == id)
                  .length;

              return _buildCategoryTile(
                title: name,
                count: count,
                trailingIcon: Icons.live_tv,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        // لا نمرر رابط؛ نمرر الـ categoryId ليتم عرض قنوات القسم مع المشغل
                        categoryId: id,
                        server: widget.server,
                        user: widget.user,
                        pass: widget.pass,
                        channelName: name,
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
            // أيقونة على يمين البلاطة داخل حاوية دائرية طفيفة
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

class _ChannelSearchDelegate extends SearchDelegate<String> {
  final IPTVProvider iptv;
  final String server, user, pass;

  _ChannelSearchDelegate(this.iptv, this.server, this.user, this.pass);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final channels = (iptv.liveData['channels'] as List?) ?? [];
    final results = channels
        .where((c) => (c['name']?.toString() ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text('لا توجد قنوات مطابقة'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final channel = results[index];
        final streamId = channel['stream_id']?.toString() ?? '';
        final channelName = channel['name'] ?? 'Unknown';
        final icon = channel['stream_icon'];

        return ListTile(
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
            final url = "$server/live/$user/$pass/$streamId.m3u8";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerScreen(
                  url: url,
                  channelName: channelName,
                  categoryId: null,
                  server: server,
                  user: user,
                  pass: pass,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

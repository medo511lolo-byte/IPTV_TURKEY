import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/iptv_provider.dart';
import 'video_player_screen.dart';

class PlayerScreen extends StatefulWidget {
  final String? url;
  final String channelName;
  final String? categoryId;
  final String? server;
  final String? user;
  final String? pass;

  const PlayerScreen({
    super.key,
    this.url,
    this.channelName = 'Player',
    this.categoryId,
    this.server,
    this.user,
    this.pass,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<Map<String, dynamic>> _filteredChannels = [];
  int _currentChannelIndex = 0;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  void _loadChannels() {
    final iptv = Provider.of<IPTVProvider>(context, listen: false);
    final allChannels = (iptv.liveData['channels'] as List?) ?? [];

    if (widget.categoryId == null || widget.categoryId == 'all') {
      _filteredChannels = List<Map<String, dynamic>>.from(allChannels);
    } else {
      _filteredChannels = allChannels
          .where((ch) => ch['category_id']?.toString() == widget.categoryId)
          .toList()
          .cast<Map<String, dynamic>>();
    }

    // تعيين أول قناة إذا لم يكن هناك URL محدد
    if (_filteredChannels.isNotEmpty) {
      _currentChannelIndex = 0;
      _currentUrl = _buildUrl(_filteredChannels[0]);
    }
  }

  String _buildUrl(Map<String, dynamic> channel) {
    final streamId = channel['stream_id']?.toString() ?? '';
    return "${widget.server}/live/${widget.user}/${widget.pass}/$streamId.m3u8";
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredChannels.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('لا توجد قنوات'),
          automaticallyImplyLeading: true,
        ),
        body: const Center(child: Text('لا توجد قنوات متاحة في هذا القسم')),
      );
    }

    final channelsWithUrls = _filteredChannels.map((ch) {
      return {
        'name': ch['name'] ?? 'قناة',
        'url': _buildUrl(ch),
      };
    }).toList();

    return VideoPlayerScreen(
      url: _currentUrl,
      title: widget.channelName,
      channels: channelsWithUrls,
      initialChannelIndex: _currentChannelIndex,
      onChannelChanged: (index) {
        setState(() {
          _currentChannelIndex = index;
          _currentUrl = _buildUrl(_filteredChannels[index]);
        });
      },
    );
  }
}

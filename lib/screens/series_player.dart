import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import '../theme.dart';
import '../services/vod_api.dart';

class SeriesPlayerScreen extends StatefulWidget {
  final String url;
  final String episodeName;
  final String? poster;
  final String? seriesId;
  final String? server;
  final String? user;
  final String? pass;

  const SeriesPlayerScreen({
    super.key,
    required this.url,
    required this.episodeName,
    this.poster,
    this.seriesId,
    this.server,
    this.user,
    this.pass,
  });

  @override
  State<SeriesPlayerScreen> createState() => _SeriesPlayerScreenState();
}

  late VlcPlayerController _vlcController;
  bool _isInitialized = false;
  List<dynamic> _episodes = [];
  bool _isLoadingEpisodes = false;
  int? _selectedEpisodeIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    _vlcController.addListener(_onVlcInit);
    _loadEpisodes();
  }

  void _onVlcInit() {
    if (_vlcController.value.isInitialized && !_isInitialized) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _vlcController.removeListener(_onVlcInit);
    _vlcController.dispose();
    super.dispose();
  }

  Future<void> _loadEpisodes() async {
    if (widget.seriesId == null || widget.server == null || widget.user == null || widget.pass == null) {
      return;
    }

    setState(() => _isLoadingEpisodes = true);
    try {
      final episodes = await VodAPI.getEpisodes(
        widget.server!,
        widget.user!,
        widget.pass!,
        widget.seriesId!,
      );
      setState(() {
        _episodes = episodes;
      });
    } catch (e) {
      // ignore
    } finally {
      setState(() => _isLoadingEpisodes = false);
    }
  }


  Future<void> _playEpisode(int index, String episodeUrl) async {
    setState(() {
      _selectedEpisodeIndex = index;
      _isInitialized = false;
    });
    _vlcController.dispose();
    _vlcController = VlcPlayerController.network(
      episodeUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    _vlcController.addListener(_onVlcInit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppTheme.darkCard,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.episodeName,
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // VLC Video Player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isInitialized
                  ? FlutterVlcPlayer(
                      controller: _vlcController,
                      aspectRatio: 16 / 9,
                      placeholder: const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
                    )
                  : const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
            ),
            // Episodes List
            if (_episodes.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'الحلقات',
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _episodes.length,
                        itemBuilder: (context, index) {
                          final episode = _episodes[index];
                          final episodeNum = episode['num'] ?? '${index + 1}';
                          final season = episode['season'] ?? '';
                          final title = episode['title'] ?? 'الحلقة $episodeNum';
                          final episodeUrl = episode['link'] ?? widget.url;

                          return GestureDetector(
                            onTap: () {
                              _playEpisode(index, episodeUrl);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _selectedEpisodeIndex == index
                                    ? const Color(0xFFFF6B35).withOpacity(0.3)
                                    : AppTheme.darkCard.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedEpisodeIndex == index
                                      ? const Color(0xFFFF6B35)
                                      : Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _selectedEpisodeIndex == index
                                          ? const Color(0xFFFF6B35)
                                          : Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        episodeNum.toString(),
                                        style: TextStyle(
                                          color: _selectedEpisodeIndex == index
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (season.isNotEmpty)
                                          Text(
                                            'الموسم $season',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedEpisodeIndex == index)
                                    const Icon(
                                      Icons.play_circle_filled,
                                      color: Color(0xFFFF6B35),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

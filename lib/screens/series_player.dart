import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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

class _SeriesPlayerScreenState extends State<SeriesPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  List<dynamic> _episodes = [];
  bool _isLoadingEpisodes = false;
  int? _selectedEpisodeIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _loadEpisodes();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
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

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFFF6B35),
          handleColor: const Color(0xFFFF6B35),
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade300,
        ),
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _playEpisode(int index, String episodeUrl) async {
    setState(() {
      _selectedEpisodeIndex = index;
    });

    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(episodeUrl));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFFF6B35),
          handleColor: const Color(0xFFFF6B35),
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade300,
        ),
      );

      if (mounted) setState(() {});
    } catch (e) {
      // ignore
    }
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
            // Video Player
            if (_isLoading)
              const AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF6B35),
                  ),
                ),
              )
            else if (_chewieController != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(controller: _chewieController!),
              )
            else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'فشل تحميل الفيديو',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
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

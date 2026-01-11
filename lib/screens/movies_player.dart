import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../theme.dart';

class MoviesPlayerScreen extends StatefulWidget {
  final String url;
  final String movieName;
  final String? poster;

  const MoviesPlayerScreen({
    super.key,
    required this.url,
    required this.movieName,
    this.poster,
  });

  @override
  State<MoviesPlayerScreen> createState() => _MoviesPlayerScreenState();
}

class _MoviesPlayerScreenState extends State<MoviesPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
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
                      widget.movieName,
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
          ],
        ),
      ),
    );
  }
}

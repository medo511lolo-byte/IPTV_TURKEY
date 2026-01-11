import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String title;
  final List<Map<String, dynamic>>? channels;
  final int? initialChannelIndex;
  final Function(int)? onChannelChanged;

  const VideoPlayerScreen({
    super.key,
    required this.url,
    required this.title,
    this.channels,
    this.initialChannelIndex,
    this.onChannelChanged,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int? _currentChannelIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentChannelIndex = widget.initialChannelIndex;
    _initializePlayer();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    setState(() => _isLoading = true);
    
    try {
      _chewieController?.dispose();
      _videoPlayerController?.dispose();

      final isHls = widget.url.toLowerCase().contains('.m3u8');
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        formatHint: isHls ? VideoFormat.hls : VideoFormat.other,
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
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'خطأ في التشغيل',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
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

  void _changeChannel(int index) {
    if (widget.channels != null && index < widget.channels!.length) {
      final channel = widget.channels![index];
      final newUrl = channel['url'] as String;
      
      setState(() {
        _currentChannelIndex = index;
      });

      widget.onChannelChanged?.call(index);
      
      _videoPlayerController?.dispose();
      _chewieController?.dispose();
      
      final isHls = newUrl.toLowerCase().contains('.m3u8');
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(newUrl),
        formatHint: isHls ? VideoFormat.hls : VideoFormat.other,
      );
      _videoPlayerController!.initialize().then((_) {
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
      });
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
                      widget.title,
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
            // Channels List
            if (widget.channels != null && widget.channels!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.channels!.length,
                  itemBuilder: (context, index) {
                    final channel = widget.channels![index];
                    final isSelected = _currentChannelIndex == index;
                    
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: const Color(0xFFFF6B35).withOpacity(0.2),
                      leading: CircleAvatar(
                        backgroundColor: isSelected 
                            ? const Color(0xFFFF6B35) 
                            : Colors.grey.shade800,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        channel['name'] ?? 'قناة ${index + 1}',
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.play_circle_filled, color: Color(0xFFFF6B35))
                          : null,
                      onTap: () => _changeChannel(index),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

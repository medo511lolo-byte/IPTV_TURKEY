import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../services/watch_history_service.dart';

class PlayerScreen extends StatefulWidget {
  final String url;
  final String channelName;
  final String? itemId;
  final String? itemType;
  final String? poster;

  const PlayerScreen({
    super.key,
    required this.url,
    this.channelName = 'Player',
    this.itemId,
    this.itemType,
    this.poster,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Timer? _watchTimer;
  bool _hasRecorded = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startWatchTimer();
  }

  void _startWatchTimer() {
    // حفظ في السجل بعد 10 ثواني
    _watchTimer = Timer(const Duration(seconds: 10), () {
      if (!_hasRecorded && widget.itemId != null && widget.itemType != null) {
        _recordWatch();
      }
    });
  }

  Future<void> _recordWatch() async {
    if (_hasRecorded) return;
    
    _hasRecorded = true;
    await WatchHistoryService.addToHistory(
      id: widget.itemId!,
      name: widget.channelName,
      type: widget.itemType!,
      poster: widget.poster,
      url: widget.url,
    );
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      allowMuting: true,
      allowFullScreen: true,
      showControls: true,
      aspectRatio: _videoController!.value.aspectRatio == 0
          ? 16 / 9
          : _videoController!.value.aspectRatio,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
        centerTitle: true,
      ),
      body: Center(
        child: _chewieController != null && _videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _chewieController!.aspectRatio ?? 16 / 9,
                child: Chewie(controller: _chewieController!),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:better_player/better_player.dart';
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
  BetterPlayerController? _betterPlayerController;
  Timer? _watchTimer;
  bool _hasRecorded = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startWatchTimer();
  }

  void _startWatchTimer() {
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
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.channelName,
        author: "IPTV Turkey",
        imageUrl: widget.poster,
      ),
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        autoDetectFullscreenDeviceOrientation: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePlayPause: true,
          enableMute: true,
          enableFullscreen: true,
          enableProgressText: true,
          enableProgressBar: true,
          enableSkips: true,
          skipBackInterval: const Duration(seconds: 10),
          skipForwardInterval: const Duration(seconds: 10),
          showControlsOnInitialize: true,
        ),
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
      ),
      betterPlayerDataSource: dataSource,
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.channelName),
        centerTitle: true,
      ),
      body: _betterPlayerController != null
          ? Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(controller: _betterPlayerController!),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

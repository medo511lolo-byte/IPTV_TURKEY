import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
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
  late VlcPlayerController _vlcController;
  bool _isInitialized = false;

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
          ],
        ),
      ),
    );
  }
}

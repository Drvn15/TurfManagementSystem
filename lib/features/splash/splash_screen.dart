import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final VideoPlayerController _videoController;
  bool _isReady = false;
  bool _navigationStarted = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/Final.mp4');
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      await _videoController.setLooping(false);
      await _videoController.play();

      _videoController.addListener(_handleVideoProgress);

      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    } catch (_) {
      _goToNextScreen();
    }
  }

  void _handleVideoProgress() {
    if (!_videoController.value.isInitialized) {
      return;
    }

    final position = _videoController.value.position;
    final duration = _videoController.value.duration;

    if (duration > Duration.zero && position >= duration) {
      _goToNextScreen();
    }
  }

  void _goToNextScreen() {
    if (_navigationStarted || !mounted) {
      return;
    }

    _navigationStarted = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) =>
            widget.nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController.removeListener(_handleVideoProgress);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isReady ? 1 : 0,
        child: SizedBox.expand(
          child: _isReady
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: VideoPlayer(_videoController),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
        ),
      ),
    );
  }
}

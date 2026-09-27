import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/widgets/app_error_view.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/core/widgets/custom_back_button.dart';
import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Full-screen player for a single lesson.
///
/// The controller is created and disposed by the state so that navigating away
/// from the page releases the platform player instead of leaking it.
class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.video});

  final VideoModel video;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialisation;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
    );
    _initialisation = _controller.initialize().then((_) {
      if (mounted) _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const CustomBackButton(
          containerColor: Colors.black,
          borderColor: Colors.white24,
          iconColor: Colors.white,
        ),
        title: Text(
          widget.video.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initialisation,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AppErrorView(
              message: 'تعذر تشغيل الفيديو. حاول مرة أخرى.',
              onRetry: () => setState(() {}),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const AppLoadingView();
          }

          return Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        },
      ),
      bottomNavigationBar: VideoProgressIndicator(
        _controller,
        allowScrubbing: true,
        colors: const VideoProgressColors(
          playedColor: AppColors.primary,
          bufferedColor: Colors.white24,
          backgroundColor: Colors.white10,
        ),
      ),
    );
  }
}
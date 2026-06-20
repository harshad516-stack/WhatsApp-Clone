// import 'package:cached_video_player/cached_video_player.dart';
// import 'package:flutter/material.dart';

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerItem({
//     Key? key,
//     required this.videoUrl,
//   }) : super(key: key);

//   @override
//   State<VideoPlayerItem> createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   late CachedVideoPlayerController videoPlayerController;
//   bool isPlay = false;

//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((value) {
//         videoPlayerController.setVolume(1);
//       });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     videoPlayerController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: Stack(
//         children: [
//           CachedVideoPlayer(videoPlayerController),
//           Align(
//             alignment: Alignment.center,
//             child: IconButton(
//               onPressed: () {
//                 if (isPlay) {
//                   videoPlayerController.pause();
//                 } else {
//                   videoPlayerController.play();
//                 }

//                 setState(() {
//                   isPlay = !isPlay;
//                 });
//               },
//               icon: Icon(
//                 isPlay ? Icons.pause_circle : Icons.play_circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool isPlaying = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }

    setState(() {
      isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          _controller.value.isInitialized ? _controller.value.aspectRatio : 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video
          _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : const Center(child: CircularProgressIndicator()),

          // Play/Pause Button
          if (!isLoading)
            IconButton(
              iconSize: 60,
              onPressed: togglePlay,
              icon: Icon(
                _controller.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
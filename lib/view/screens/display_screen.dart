import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_video/view/widgets/Album_Rotator.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controller/video_controller.dart';
import '../../model/video.dart';
import 'comment_screen.dart';
import 'trending_screen.dart';

class DisplayVideoScreen extends StatefulWidget {
  const DisplayVideoScreen({super.key});

  @override
  State<DisplayVideoScreen> createState() => _DisplayVideoScreenState();
}

class _DisplayVideoScreenState extends State<DisplayVideoScreen> {
  final PageController pageController = PageController();
  final VideoController videoController = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔥 TRENDING BUTTON ON TOP
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Reels"),
        actions: [
          IconButton(
            icon: const Icon(Icons.trending_up),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrendingScreen(),
                ),
              );
            },
          )
        ],
      ),

      body: Obx(() {
        if (videoController.videoList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          controller: pageController,
          itemCount: videoController.videoList.length,
          itemBuilder: (context, index) {
            return VideoPlayerItem(
              video: videoController.videoList[index],
            );
          },
        );
      }),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final Video video;

  const VideoPlayerItem({super.key, required this.video});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  final VideoController videoController = Get.find();

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });

    /// 👁 REAL TIME VIEW COUNTER
    videoController.addView(widget.video.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [

        /// 🎥 VIDEO PLAYER
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),

        /// 👉 RIGHT ACTIONS
        Positioned(
          right: 12,
          bottom: 90,
          child: Column(
            children: [

              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(widget.video.profilePic),
              ),

              const SizedBox(height: 20),

              /// ❤️ LIKE
              GestureDetector(
                onTap: () => videoController.likeVideo(widget.video.id),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: widget.video.likes.contains(
                        FirebaseAuth.instance.currentUser!.uid,
                      )
                          ? Colors.red
                          : Colors.white,
                      size: 32,
                    ),
                    Text(
                      widget.video.likes.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ⭐ SAVE
              GestureDetector(
                onTap: () => videoController.saveVideo(widget.video.id),
                child: Icon(
                  Icons.bookmark,
                  color: widget.video.savedBy.contains(
                    FirebaseAuth.instance.currentUser!.uid,
                  )
                      ? Colors.yellow
                      : Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              /// 🔁 SHARE
              GestureDetector(
                onTap: () => videoController.shareVideo(widget.video),
                child: Column(
                  children: [
                    const Icon(Icons.reply, color: Colors.white, size: 32),
                    Text(
                      widget.video.shareCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// 💬 COMMENTS
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.black,
                    builder: (_) =>
                        CommentScreen(videoId: widget.video.id),
                  );
                },
                child: _icon(Icons.comment, "Comments"),
              ),

              const SizedBox(height: 60),

              AlbumRotator(
                profilePicUrl: widget.video.profilePic,
              ),
            ],
          ),
        ),

        /// 📄 VIDEO INFO
        Positioned(
          left: 12,
          bottom: 30,
          right: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@${widget.video.username}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                widget.video.caption,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              Text(
                "${widget.video.views} views",
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _icon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/trending_controller.dart';
import '../../model/video.dart';

class TrendingScreen extends StatelessWidget {
  TrendingScreen({super.key});

  final TrendingController controller =
  Get.put(TrendingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🔥 Trending"),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.trendingVideos.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: controller.trendingVideos.length,
          itemBuilder: (context, index) {
            Video video = controller.trendingVideos[index];

            return ListTile(
              leading: Image.network(
                video.thumbnail,
                width: 80,
                fit: BoxFit.cover,
              ),
              title: Text(
                video.caption,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "${video.views} views • ${video.likes.length} likes",
                style: const TextStyle(color: Colors.white54),
              ),
            );
          },
        );
      }),
    );
  }
}

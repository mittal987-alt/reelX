import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/comment_controller.dart';

class CommentScreen extends StatelessWidget {
  final String videoId;

  CommentScreen({super.key, required this.videoId}) {
    commentController.fetchComments(videoId);
  }

  final CommentController commentController =
  Get.put(CommentController());

  final TextEditingController textController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      color: Colors.black,
      child: Column(
        children: [

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Comments",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),

          /// 📥 REALTIME COMMENTS
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: commentController.commentList.length,
                itemBuilder: (context, index) {

                  final comment =
                  commentController.commentList[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      comment["profilePic"] != null &&
                          comment["profilePic"]
                              .toString()
                              .isNotEmpty
                          ? NetworkImage(comment["profilePic"])
                          : const Icon(Icons.person)
                      as ImageProvider,
                    ),
                    title: Text(
                      comment["username"],
                      style:
                      const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      comment["text"],
                      style: const TextStyle(
                          color: Colors.white70),
                    ),
                  );
                },
              );
            }),
          ),

          /// ✍ WRITE COMMENT
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style:
                    const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle:
                      TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Colors.white),
                  onPressed: () {
                    if (textController.text.trim().isEmpty)
                      return;

                    commentController.postComment(
                      videoId,
                      textController.text.trim(),
                    );

                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

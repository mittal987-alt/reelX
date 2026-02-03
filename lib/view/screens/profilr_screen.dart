import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:video_video/view/screens/saved_video_screen.dart';

import '../../model/user.dart';
import '../../model/video.dart';
import '../../controller/follow_controller.dart';
import '../../controller/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  final MyUser user;

  ProfileScreen({super.key, required this.user});

  final FollowController followController =
  Get.put(FollowController());

  @override
  Widget build(BuildContext context) {
    final String currentUid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(user.username),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final updatedUser = MyUser.fromSnap(snapshot.data!);
          bool isFollowing =
          updatedUser.followers.contains(currentUid);

          return Column(
            children: [

              /// 👤 PROFILE HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage:
                      NetworkImage(updatedUser.profilePic),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      updatedUser.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      updatedUser.email,
                      style: const TextStyle(color: Colors.white54),
                    ),

                    const SizedBox(height: 12),

                    /// 📊 COUNTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _countBox("Followers",
                            updatedUser.followers.length),
                        const SizedBox(width: 20),
                        _countBox("Following",
                            updatedUser.following.length),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// ➕ FOLLOW / UNFOLLOW
                    ElevatedButton(
                      onPressed: () {
                        followController.followUser(updatedUser.uid);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isFollowing ? Colors.grey : Colors.red,
                      ),
                      child: Text(
                          isFollowing ? "Unfollow" : "Follow"),
                    ),

                    const SizedBox(height: 10),

                    /// ⭐ SAVED VIDEOS
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const SavedVideoScreen(),
                          ),
                        );
                      },
                      child: const Text("Saved Videos ⭐"),
                    ),

                    const SizedBox(height: 15),

                    /// ⚙ PROFILE ACTIONS
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [

                        _actionBtn("Change Username", () {
                          _changeUsername(context, updatedUser.uid);
                        }),

                        _actionBtn("Change Photo", () {
                          AuthController.instance.pickImage();
                        }),

                        _actionBtn("Reset Password", () {
                          AuthController.instance
                              .resetPassword(updatedUser.email);
                        }),

                        _actionBtn("Logout", () {
                          AuthController.instance.logout();
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24),

              /// 🎥 USER VIDEOS GRID
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("videos")
                      .where("uid",
                      isEqualTo: updatedUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No videos yet",
                          style:
                          TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: docs.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        Video video =
                        Video.fromSnap(docs[index]);

                        return Image.network(
                          video.thumbnail,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔢 FOLLOW COUNT BOX
  Widget _countBox(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }

  /// 🎯 SMALL BUTTON
  Widget _actionBtn(String text, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }

  /// ✏ CHANGE USERNAME DIALOG
  void _changeUsername(BuildContext context, String uid) {
    TextEditingController controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Username"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .update({
                "username": controller.text.trim(),
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

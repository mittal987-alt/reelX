import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  RxList<Map<String, dynamic>> commentList = <Map<String, dynamic>>[].obs;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  /// 🔴 REALTIME FETCH
  void fetchComments(String videoId) {
    FirebaseFirestore.instance
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .orderBy("time")
        .snapshots()
        .listen((snapshot) {
      commentList.value =
          snapshot.docs.map((e) => e.data()).toList();
    });
  }

  /// 🟢 POST COMMENT
  Future<void> postComment(String videoId, String text) async {
    if (text.trim().isEmpty) return;

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .add({
      "text": text,
      "uid": uid,
      "username": userDoc["username"],
      "profilePic": userDoc["profilePic"],
      "time": FieldValue.serverTimestamp(),
    });

    /// 🔥 increment comment count
    FirebaseFirestore.instance
        .collection("videos")
        .doc(videoId)
        .update({
      "commentCount": FieldValue.increment(1),
    });
  }
}

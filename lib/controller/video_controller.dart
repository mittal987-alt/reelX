import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../model/video.dart';

class VideoController extends GetxController {

  final RxList<Video> videoList = <Video>[].obs;        // HOME FEED
  final RxList<Video> trendingList = <Video>[].obs;    // TRENDING FEED

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    fetchHomeFeed();
    fetchTrendingFeed();
  }

  // ================= HOME FEED (LATEST VIDEOS) =================
  void fetchHomeFeed() {
    videoList.bindStream(
      FirebaseFirestore.instance
          .collection("videos")
          .orderBy("createdAt", descending: true)
          .limit(10)
          .snapshots()
          .map(
            (snapshot) =>
            snapshot.docs.map((e) => Video.fromSnap(e)).toList(),
      ),
    );
  }

  // ================= TRENDING FEED =================
  void fetchTrendingFeed() {
    trendingList.bindStream(
      FirebaseFirestore.instance
          .collection("videos")
          .orderBy("views", descending: true)
          .snapshots()
          .map(
            (snapshot) =>
            snapshot.docs.map((e) => Video.fromSnap(e)).toList(),
      ),
    );
  }

  // ================= LIKE =================
  Future<void> likeVideo(String id) async {
    var ref = FirebaseFirestore.instance.collection("videos").doc(id);

    var doc = await ref.get();
    List likes = doc["likes"];

    if (likes.contains(uid)) {
      await ref.update({
        "likes": FieldValue.arrayRemove([uid]),
      });
    } else {
      await ref.update({
        "likes": FieldValue.arrayUnion([uid]),
      });
    }
  }

  // ================= SAVE =================
  Future<void> saveVideo(String id) async {
    var ref = FirebaseFirestore.instance.collection("videos").doc(id);

    var doc = await ref.get();
    List saved = doc["savedBy"];

    if (saved.contains(uid)) {
      await ref.update({
        "savedBy": FieldValue.arrayRemove([uid]),
      });
    } else {
      await ref.update({
        "savedBy": FieldValue.arrayUnion([uid]),
      });
    }
  }

  // ================= VIEW =================
  Future<void> addView(String id) async {
    await FirebaseFirestore.instance
        .collection("videos")
        .doc(id)
        .update({
      "views": FieldValue.increment(1),
    });
  }

  // ================= SHARE =================
  Future<void> shareVideo(Video video) async {
    await Share.share("Check this video 🔥\n${video.videoUrl}");

    await FirebaseFirestore.instance
        .collection("videos")
        .doc(video.id)
        .update({
      "shareCount": FieldValue.increment(1),
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/video.dart';

class TrendingController extends GetxController {
  RxList<Video> trendingVideos = <Video>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrending();
  }

  void fetchTrending() {
    FirebaseFirestore.instance
        .collection("videos")
        .snapshots()
        .listen((snapshot) {

      List<Video> vids =
      snapshot.docs.map((e) => Video.fromSnap(e)).toList();

      vids.sort((a, b) {
        int scoreA = a.views + a.likes.length + a.shareCount;
        int scoreB = b.views + b.likes.length + b.shareCount;
        return scoreB.compareTo(scoreA);
      });

      trendingVideos.value = vids;
    });
  }
}

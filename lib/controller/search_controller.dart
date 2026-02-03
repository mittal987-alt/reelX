import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/user.dart';

class SearchControllerX extends GetxController {
  RxList<MyUser> searchResults = <MyUser>[].obs;
  RxList<MyUser> history = <MyUser>[].obs;
  RxList<MyUser> suggestions = <MyUser>[].obs;
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void searchUser(String query) async {
    if (query.isEmpty) return;

    var snap = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: query)
        .get();

    searchResults.value =
        snap.docs.map((e) => MyUser.fromSnap(e)).toList();
  }
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: query)
        .where("username", isLessThan: query + 'z')
        .limit(6)
        .get();

    suggestions.value =
        snap.docs.map((e) => MyUser.fromSnap(e)).toList();
  }
  Future<void> saveHistory(MyUser user) async {
    await FirebaseFirestore.instance
        .collection("searchHistory")
        .doc(uid)
        .collection("users")
        .doc(user.uid)
        .set(user.toJson());

    fetchHistory();
  }

  void fetchHistory() {
    FirebaseFirestore.instance
        .collection("searchHistory")
        .doc(uid)
        .collection("users")
        .snapshots()
        .listen((snap) {
      history.value =
          snap.docs.map((e) => MyUser.fromSnap(e)).toList();
    });
  }

  Future<void> clearHistory() async {
    var snap = await FirebaseFirestore.instance
        .collection("searchHistory")
        .doc(uid)
        .collection("users")
        .get();

    for (var d in snap.docs) {
      d.reference.delete();
    }
  }
}

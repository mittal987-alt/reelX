import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String uid;
  String username;
  String email;
  String profilePic;
  List followers;
  List following;

  MyUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilePic,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "email": email,
    "profilePic": profilePic,
    "followers": followers,
    "following": following,
  };
  static MyUser fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return MyUser(
      uid: data['uid'] ?? "",
      username: data['username'] ?? "",
      email: data['email'] ?? "",
      profilePic: data['profilePic'] ?? "",   // ✅ FIXED
      followers: data['followers'] ?? [],
      following: data['following'] ?? [],
    );
  }


}

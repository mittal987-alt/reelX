import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String uid;
  final String username;
  final String profilePic;
  final String text;
  final Timestamp createdAt;

  Comment({
    required this.id,
    required this.uid,
    required this.username,
    required this.profilePic,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "uid": uid,
    "username": username,
    "profilePic": profilePic,
    "text": text,
    "createdAt": createdAt,
  };

  factory Comment.fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Comment(
      id: data["id"],
      uid: data["uid"],
      username: data["username"],
      profilePic: data["profilePic"],
      text: data["text"],
      createdAt: data["createdAt"],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String uid;
  final String username;
  final String profilePic;
  final String songname;
  final String caption;
  final String videoUrl;
  final String thumbnail;

  final List likes;
  final List savedBy;     // ⭐ saved users
  final int commentCount;
  final int shareCount;
  final int views;       // 👁 view counter

  Video({
    required this.id,
    required this.uid,
    required this.username,
    required this.profilePic,
    required this.songname,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.likes,
    required this.savedBy,
    required this.commentCount,
    required this.shareCount,
    required this.views,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "uid": uid,
    "username": username,
    "profilePic": profilePic,
    "songname": songname,
    "caption": caption,
    "videoUrl": videoUrl,
    "thumbnail": thumbnail,
    "likes": likes,
    "savedBy": savedBy,
    "commentCount": commentCount,
    "shareCount": shareCount,
    "views": views,
  };

  static Video fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Video(
      id: data["id"],
      uid: data["uid"],
      username: data["username"],
      profilePic: data["profilePic"]??"",
      songname: data["songname"],
      caption: data["caption"],
      videoUrl: data["videoUrl"],
      thumbnail: data["thumbnail"],
      likes: data["likes"] ?? [],
      savedBy: data["savedBy"] ?? [],
      commentCount: data["commentCount"] ?? 0,
      shareCount: data["shareCount"] ?? 0,
      views: data["views"] ?? 0,
    );
  }
}

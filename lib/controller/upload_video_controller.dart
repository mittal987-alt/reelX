import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import 'package:video_video/model/video.dart';

class UploadVideoController extends GetxController {
  final Uuid uuid = const Uuid();

  // ================= THUMBNAIL =================

  Future<File> _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(
      videoPath,
      quality: 50,
    );
    return thumbnail;
  }

  Future<String> _uploadThumbnail(
      String videoId, String videoPath) async {
    Reference ref =
    FirebaseStorage.instance.ref().child("thumbnails/$videoId");

    File thumbFile = await _getThumbnail(videoPath);

    UploadTask task = ref.putFile(thumbFile);
    TaskSnapshot snap = await task;

    return await snap.ref.getDownloadURL();
  }

  // ================= VIDEO =================

  Future<File?> _compressVideo(String videoPath) async {
    final info = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
    );

    return info?.file;
  }

  Future<String> _uploadVideo(String videoId, String videoPath) async {
    Reference ref =
    FirebaseStorage.instance.ref().child("videos/$videoId");

    File? compressed = await _compressVideo(videoPath);

    UploadTask task = ref.putFile(compressed!);
    TaskSnapshot snap = await task;

    return await snap.ref.getDownloadURL();
  }

  // ================= MAIN =================

  Future<void> uploadVideo(
      String songName, String caption, String videoPath) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      String videoId = uuid.v1();

      String videoUrl = await _uploadVideo(videoId, videoPath);
      String thumbnailUrl =
      await _uploadThumbnail(videoId, videoPath);

      /// ✅ VIDEO MODEL WITH SHARE COUNT
      Video video = Video(
        id: videoId,
        uid: uid,
        username: userDoc["username"],
        profilePic: userDoc["profilePic"]??
            userDoc["profilePhoto"],
        songname: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnailUrl,

        likes: [],
        savedBy: [],     // ✅ ADD
        commentCount: 0,
        shareCount: 0,
        views: 0,        // ✅ ADD
      );


      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoId)
          .set({
        ...video.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Video uploaded successfully 🎉");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    VideoCompress.dispose();
    super.onClose();
  }
}

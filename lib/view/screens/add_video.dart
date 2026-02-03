import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:video_video/constants.dart';
import 'addcaption_screen.dart';
class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  Future<void> videoPick(
      BuildContext context,
      ImageSource src,
      ) async {
    final video = await ImagePicker().pickVideo(source: src);

    if (video != null) {
      Get.snackbar("Video selected", video.path);

      Navigator.pop(context); // close dialog

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddCaptionScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    } else {
      Get.snackbar("Error", "Choose a different video");
    }
  }

  void showDialogOpt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Select Video"),
        children: [
          SimpleDialogOption(
            onPressed: () => videoPick(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
          SimpleDialogOption(
            onPressed: () => videoPick(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showDialogOpt(context),
          child: Container(
            width: 120,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Add Video",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

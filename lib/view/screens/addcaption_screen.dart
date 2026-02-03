import 'package:flutter/material.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';
import 'package:video_video/view/widgets/text_input.dart';
import 'package:get/get.dart';

import 'package:video_video/controller/upload_video_controller.dart';// 👈 FIX PATH

class AddCaptionScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const AddCaptionScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<AddCaptionScreen> createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {
  late VideoPlayerController videoPlayerController;

  final UploadVideoController videoUploadController =
  Get.put(UploadVideoController());

  final TextEditingController songNameController = TextEditingController();
  final TextEditingController captionNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    videoPlayerController =
        VideoPlayerController.file(widget.videoFile);

    videoPlayerController.initialize().then((_) {
      setState(() {});
      videoPlayerController.play();
      videoPlayerController.setLooping(true);
      videoPlayerController.setVolume(0.7);
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    songNameController.dispose();
    captionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.4,
              child: videoPlayerController.value.isInitialized
                  ? VideoPlayer(videoPlayerController)
                  : const Center(child: CircularProgressIndicator()),
            ),

            const SizedBox(height: 20),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextInputField(
                    controller: songNameController,
                    myIcon: Icons.music_note,
                    myLabelText: "Song name",
                  ),

                  const SizedBox(height: 20),

                  TextInputField(
                    controller: captionNameController,
                    myIcon: Icons.closed_caption,
                    myLabelText: "Caption",
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      videoUploadController.uploadVideo(
                        songNameController.text,
                        captionNameController.text,
                        widget.videoPath,
                      );
                    },
                    child: const Text("Upload"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

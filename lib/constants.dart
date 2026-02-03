import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_video/view/screens/comment_screen.dart';
import 'package:video_video/view/screens/saved_video_screen.dart';
import 'package:video_video/view/screens/trending_screen.dart';

import 'model/user.dart';
import 'view/screens/display_screen.dart';
import 'view/screens/search_screen.dart';
import 'view/screens/add_video.dart';
import 'view/screens/profilr_screen.dart';
import 'package:video_video/view/screens/comment_screen.dart';
const backgroundColor = Colors.black;
final Color buttonColor = Colors.red.shade400;
const borderColor = Colors.grey;
final List<Widget> pageindex = [
  const DisplayVideoScreen(),   // Home reels
  SearchScreen(),               // Search
  AddVideoScreen(),             // Upload
  Center(
    child: Text(
      "Messages",
      style: TextStyle(color: Colors.white),
    ),
  ),
  ProfileScreen(
    user: MyUser(
      uid: FirebaseAuth.instance.currentUser!.uid,
      username: "",
      email: "",
      profilePic: "",
      followers: [],
      following: [],
    ),
  ),
];

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_video/controller/auth_controller.dart';
import 'package:video_video/view/screens/auth/login_screen.dart';
import 'package:video_video/view/screens/auth/signup_screen.dart';
import 'constants.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  ).then((value){
    Get.put(AuthController());
  }
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const SignupScreen(),
    );
  }
}



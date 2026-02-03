import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/HomeScreen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  Rx<File?> proimg = Rx<File?>(null);
  late Rx<User?> _user;

  User get user => _user.value!;

  // ================= IMAGE PICK + UPDATE =================

  Future<void> pickImage() async {
    final image =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profilePics")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await ref.putFile(file);

    String url = await ref.getDownloadURL();

    /// 🔥 Update in Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"profilePic": url});

    Get.snackbar("Success", "Profile photo updated");
  }

  // ================= AUTH STATE =================

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialView);
  }

  void _setInitialView(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => Homescreen());
    }
  }

  // ================= SIGNUP =================

  Future<void> signup(
      String username,
      String email,
      String password,
      ) async {
    try {
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          proimg.value == null) {
        Get.snackbar("Error", "Please fill all fields");
        return;
      }

      UserCredential cred =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl = await _uploadProPic(proimg.value!);

      MyUser user = MyUser(
        uid: cred.user!.uid,
        username: username,
        email: email,
        profilePic: imageUrl,
        followers: [],
        following: [],
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set(user.toJson());
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
    }
  }

  // ================= UPLOAD PIC ON SIGNUP =================

  Future<String> _uploadProPic(File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profilePics")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  // ================= LOGIN =================

  Future<void> login(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar('Error', 'Enter all details');
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // ================= RESET PASSWORD =================

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);

    Get.snackbar(
      "Reset link sent",
      "Check your email to reset password",
    );
  }
}

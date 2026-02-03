import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  Future<void> followUser(String targetUserId) async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference currentUserRef =
    FirebaseFirestore.instance.collection("users").doc(currentUid);

    DocumentReference targetUserRef =
    FirebaseFirestore.instance.collection("users").doc(targetUserId);

    DocumentSnapshot currentSnap = await currentUserRef.get();

    List following = (currentSnap.data() as Map)["following"];

    if (following.contains(targetUserId)) {
      // UNFOLLOW
      await currentUserRef.update({
        "following": FieldValue.arrayRemove([targetUserId])
      });

      await targetUserRef.update({
        "followers": FieldValue.arrayRemove([currentUid])
      });
    } else {
      // FOLLOW
      await currentUserRef.update({
        "following": FieldValue.arrayUnion([targetUserId])
      });

      await targetUserRef.update({
        "followers": FieldValue.arrayUnion([currentUid])
      });
    }
  }
}

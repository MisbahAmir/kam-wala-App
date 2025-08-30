// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class TokenService {
//   static Future<void> saveWorkerToken(String workerDocId) async {
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     if (fcmToken != null) {
//       await FirebaseFirestore.instance
//           .collection('workers')
//           .doc(workerDocId)
//           .set({
//             'fcmToken': fcmToken,
//             'tokenUpdatedAt': FieldValue.serverTimestamp(),
//           }, SetOptions(merge: true));
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenService {
  static Future<void> saveWorkerToken(String workerId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection("workers")
            .doc(workerId)
            .update({"fcmToken": token});
      }
    } catch (e) {
      print("Error saving worker token: $e");
    }
  }

  static Future<void> saveAdminToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection("admin_tokens")
            .doc("main_admin")
            .set({"fcmToken": token});
      }
    } catch (e) {
      print("Error saving admin token: $e");
    }
  }
}

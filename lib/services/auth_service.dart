import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Signup with role
  Future<User?> signupWithRole({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      await _firestore.collection("users").doc(user!.uid).set({
        "name": name,
        "phone": phone,
        "email": email,
        "role": role,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return user;
    } catch (e) {
      print("Signup Error: $e");
      return null;
    }
  }

  // ✅ Login and get user role
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot snap =
          await _firestore.collection("users").doc(cred.user!.uid).get();

      if (snap.exists) {
        return {"role": snap["role"], "email": snap["email"]};
      } else {
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // ✅ Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<User?> signupWithRole({
//     required String name,
//     required String phone,
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);

//       User? user = userCredential.user;

//       await _firestore.collection("users").doc(user!.uid).set({
//         "name": name,
//         "phone": phone,
//         "email": email,
//         "role": role,
//         "createdAt": FieldValue.serverTimestamp(),
//       });

//       return user;
//     } catch (e) {
//       print("Signup Error: $e");
//       return null;
//     }
//   }
//}

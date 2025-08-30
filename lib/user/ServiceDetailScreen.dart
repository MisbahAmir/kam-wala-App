// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ServiceDetailScreen extends StatelessWidget {
//   final String serviceName;
//   final String subtitle;
//   final IconData icon;

//   const ServiceDetailScreen({
//     super.key,
//     required this.serviceName,
//     required this.subtitle,
//     required this.icon,
//   });

//   Future<void> _logServiceClick() async {
//     await FirebaseFirestore.instance.collection('service_clicks').add({
//       'service': serviceName,
//       'timestamp': Timestamp.now(),
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _logServiceClick();

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         title: Text(serviceName, style: const TextStyle(color: Colors.black)),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, size: 100, color: Colors.yellow),
//             const SizedBox(height: 20),
//             Text(
//               serviceName,
//               style: GoogleFonts.poppins(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               subtitle,
//               style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Service requested!"),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.yellow,
//                 foregroundColor: Colors.black,
//               ),
//               child: const Text("Request this Service"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final String subtitle;
  final IconData icon;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.subtitle,
    required this.icon,
  });

  /// Logs service click for analytics
  Future<void> _logServiceClick() async {
    await FirebaseFirestore.instance.collection('service_clicks').add({
      'service': serviceName,
      'timestamp': Timestamp.now(),
    });
  }

  /// Requests a service and saves full user details and request info in Firestore
  Future<void> _requestService(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please log in to request a service."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Fetch user details from Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final userData = userDoc.data();

      await FirebaseFirestore.instance.collection('service_requests').add({
        'service': serviceName,
        'subtitle': subtitle,
        'timestamp': Timestamp.now(),
        'userId': user.uid,
        'userEmail': user.email,
        'userName': userData?['name'] ?? 'Unknown',
        'userPhone': userData?['phone'] ?? '',
        'status': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service requested successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _logServiceClick(); // Log when screen opens

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(serviceName, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 100, color: Colors.yellow),
            const SizedBox(height: 20),
            Text(
              serviceName,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _requestService(context),
              icon: const Icon(Icons.send),
              label: const Text("Request this Service"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ServiceDetailScreen extends StatelessWidget {
//   final String serviceName;
//   final String subtitle;
//   final IconData icon;

//   const ServiceDetailScreen({
//     super.key,
//     required this.serviceName,
//     required this.subtitle,
//     required this.icon,
//   });

//   Future<void> _logServiceClick() async {
//     await FirebaseFirestore.instance.collection('service_clicks').add({
//       'service': serviceName,
//       'timestamp': Timestamp.now(),
//     });
//   }

//   Future<void> _requestService(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please log in to request a service."),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Get more user details from Firestore
//     final userDoc =
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//     final userData = userDoc.data();

//     await FirebaseFirestore.instance.collection('service_requests').add({
//       'service': serviceName,
//       'subtitle': subtitle,
//       'timestamp': Timestamp.now(),
//       'userId': user.uid,
//       'userEmail': user.email,
//       'userName': userData?['name'] ?? 'Unknown',
//       'userPhone': userData?['phone'] ?? '',
//       'status': 'pending', // can be pending, approved, rejected
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Service requested successfully!"),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _logServiceClick();

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         title: Text(serviceName, style: const TextStyle(color: Colors.black)),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, size: 100, color: Colors.yellow),
//             const SizedBox(height: 20),
//             Text(
//               serviceName,
//               style: GoogleFonts.poppins(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               subtitle,
//               style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               onPressed: () => _requestService(context),
//               icon: const Icon(Icons.send),
//               label: const Text("Request this Service"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.yellow,
//                 foregroundColor: Colors.black,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 textStyle: const TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

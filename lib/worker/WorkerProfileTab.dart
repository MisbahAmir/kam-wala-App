// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class WorkerProfileTab extends StatefulWidget {
//   const WorkerProfileTab({super.key});

//   @override
//   State<WorkerProfileTab> createState() => _WorkerProfileTabState();
// }

// class _WorkerProfileTabState extends State<WorkerProfileTab> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final doc =
//         await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     if (doc.exists) {
//       final data = doc.data()!;
//       _nameController.text = data['name'] ?? '';
//       _phoneController.text = data['phone'] ?? '';
//     }
//     setState(() => _isLoading = false);
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     await FirebaseFirestore.instance.collection('users').doc(uid).set({
//       'name': _nameController.text.trim(),
//       'phone': _phoneController.text.trim(),
//       'email': FirebaseAuth.instance.currentUser?.email ?? '',
//       'role': 'Worker',
//       'updatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Profile updated')));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())

//         : SingleChildScrollView(

//           padding: const EdgeInsets.all(20),

//           child: Column(
//             backgroundColor: Colors.grey.shade300,
//             children: [
//               const SizedBox(height: 20),
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey.shade300,
//                 child: Icon(
//                   Icons.person,
//                   size: 50,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'My Profile',
//                 style: GoogleFonts.poppins(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             labelText: 'Full Name',
//                             prefixIcon: const Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           validator:
//                               (value) =>
//                                   value == null || value.isEmpty
//                                       ? 'Enter your name'
//                                       : null,
//                         ),
//                         const SizedBox(height: 20),
//                         TextFormField(
//                           controller: _phoneController,
//                           keyboardType: TextInputType.phone,
//                           decoration: InputDecoration(
//                             labelText: 'Phone Number',
//                             prefixIcon: const Icon(Icons.phone),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           validator:
//                               (value) =>
//                                   value == null || value.isEmpty
//                                       ? 'Enter phone number'
//                                       : null,
//                         ),
//                         const SizedBox(height: 24),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: _saveProfile,
//                             icon: const Icon(Icons.save),
//                             label: const Text('Save Profile'),
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               backgroundColor: Colors.black,
//                               foregroundColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerProfileTab extends StatefulWidget {
  const WorkerProfileTab({super.key});

  @override
  State<WorkerProfileTab> createState() => _WorkerProfileTabState();
}

class _WorkerProfileTabState extends State<WorkerProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': FirebaseAuth.instance.currentUser?.email ?? '',
      'role': 'Worker',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("User not logged in"));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No profile data found"));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter your name'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter phone number'
                                    : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _saveProfile,
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class WorkerProfileTab extends StatefulWidget {
//   const WorkerProfileTab({super.key});

//   @override
//   State<WorkerProfileTab> createState() => _WorkerProfileTabState();
// }

// class _WorkerProfileTabState extends State<WorkerProfileTab> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//     final doc =
//         await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     if (doc.exists) {
//       final data = doc.data()!;
//       _nameController.text = data['name'] ?? '';
//       _phoneController.text = data['phone'] ?? '';
//     }
//     setState(() => _isLoading = false);
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//     await FirebaseFirestore.instance.collection('users').doc(uid).set({
//       'name': _nameController.text.trim(),
//       'phone': _phoneController.text.trim(),
//       'email': FirebaseAuth.instance.currentUser?.email ?? '',
//       'role': 'Worker',
//       'updatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Profile updated')));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Center(
//             child: Card(
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const Text(
//                         'My Profile',
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Full Name',
//                           prefixIcon: const Icon(Icons.person),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         validator:
//                             (value) =>
//                                 value == null || value.isEmpty
//                                     ? 'Enter your name'
//                                     : null,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           prefixIcon: const Icon(Icons.phone),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         validator:
//                             (value) =>
//                                 value == null || value.isEmpty
//                                     ? 'Enter phone number'
//                                     : null,
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton.icon(
//                         onPressed: _saveProfile,
//                         icon: const Icon(Icons.save),
//                         label: const Text('Save'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           foregroundColor: Colors.white,
//                           minimumSize: const Size(double.infinity, 50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//   }
// }

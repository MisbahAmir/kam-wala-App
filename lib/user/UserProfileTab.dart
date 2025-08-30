// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kam_wala_app/user/UserHomeTab.dart';

// class UserProfileSetupScreen extends StatefulWidget {
//   const UserProfileSetupScreen({super.key});

//   @override
//   State<UserProfileSetupScreen> createState() => _UserProfileSetupScreenState();
// }

// class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _submitProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'fullName': _nameController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'address': _addressController.text.trim(),
//         'email': user.email,
//         'uid': user.uid,
//         'role': 'user',
//       });

//       Navigator.push(context, MaterialPageRoute(builder: (_) => UserHomeTab()));
//     }

//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         title: const Text("Set Up Your Profile"),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.asset(
//                 'assets/pic/user profile.jpg', // replace with your image path
//                 height: 365,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 25),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Text(
//                     "Let's complete your profile to proceed.",
//                     style: GoogleFonts.poppins(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   _buildField(
//                     label: "Full Name",
//                     controller: _nameController,
//                     icon: Icons.person,
//                   ),
//                   _buildField(
//                     label: "Phone Number",
//                     controller: _phoneController,
//                     keyboard: TextInputType.phone,
//                     icon: Icons.phone,
//                   ),
//                   _buildField(
//                     label: "Address",
//                     controller: _addressController,
//                     icon: Icons.home,
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: isLoading ? null : _submitProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.yellow[700],
//                       foregroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 16,
//                         horizontal: 32,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       textStyle: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     child:
//                         isLoading
//                             ? const CircularProgressIndicator(
//                               color: Colors.black,
//                             )
//                             : const Text("Save & Continue"),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildField({
//     required String label,
//     required TextEditingController controller,
//     TextInputType keyboard = TextInputType.text,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboard,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: GoogleFonts.poppins(color: Colors.white70),
//           filled: true,
//           fillColor: const Color(0xFF1E1E1E),
//           prefixIcon:
//               icon != null ? Icon(icon, color: Colors.yellow[700]) : null,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.yellow[700]!),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.white),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//         ),
//         validator:
//             (value) =>
//                 value == null || value.trim().isEmpty ? 'Required' : null,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kam_wala_app/user/UserHomeTab.dart';

class UserProfileSetupScreen extends StatefulWidget {
  const UserProfileSetupScreen({super.key});

  @override
  State<UserProfileSetupScreen> createState() => _UserProfileSetupScreenState();
}

class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool isLoading = false;

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'email': user.email,
        'uid': user.uid,
        'role': 'user',
      });

      Navigator.push(context, MaterialPageRoute(builder: (_) => UserHomeTab()));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Set Up Your Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Profile image with shadow and rounded corners
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/pic/user profile.jpg',
                  height: 365,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Let's complete your profile to proceed.",
                    style: GoogleFonts.poppins(
                      color: Colors.blueGrey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildField(
                    label: "Full Name",
                    controller: _nameController,
                    icon: Icons.person,
                  ),
                  _buildField(
                    label: "Phone Number",
                    controller: _phoneController,
                    keyboard: TextInputType.phone,
                    icon: Icons.phone,
                  ),
                  _buildField(
                    label: "Address",
                    controller: _addressController,
                    icon: Icons.home,
                  ),
                  const SizedBox(height: 30),
                  // Modern gradient button with shadow
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 36,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      shadowColor: Colors.blue.shade200,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade700, Colors.blue.shade400],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  "Save & Continue",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.blueGrey.shade700),
          filled: true,
          fillColor: Colors.white,
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.blue.shade700) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator:
            (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}

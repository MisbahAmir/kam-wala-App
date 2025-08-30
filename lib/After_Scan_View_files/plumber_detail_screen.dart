import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlumberDetailScreen extends StatefulWidget {
  const PlumberDetailScreen({super.key});

  @override
  State<PlumberDetailScreen> createState() => _PlumberDetailScreenState();
}

class _PlumberDetailScreenState extends State<PlumberDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> _logServiceRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to request the service")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final requestData = {
      'uid': user.uid,
      'userEmail': user.email ?? '',
      'userName': nameController.text.trim(),
      'userPhone': phoneController.text.trim(),
      'userAddress': addressController.text.trim(),
      'service': 'Plumber',
      'timestamp': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('service_requests')
        .add(requestData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Request sent!"),
        backgroundColor: Colors.green,
      ),
    );

    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      // appBar: AppBar(
      //   title: const Text("Plumber", style: TextStyle(color: Colors.black)),
      //   backgroundColor: Colors.yellow,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(390),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/pic/DRILMAN.png',
                // Add thi image to assets
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            "",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),

      // appBar: AppBar(
      //   backgroundColor: Colors.yellow.shade600,
      //   elevation: 4,
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   centerTitle: true,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      //   ),
      //   title: Text(
      //     "Plumber",
      //     style: GoogleFonts.poppins(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w600,
      //       fontSize: 22,
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.plumbing, size: 100, color: Colors.black),
              const SizedBox(height: 15),
              Text(
                "Plumber Services",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 254, 197, 8),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(nameController, "Your Name"),
                    const SizedBox(height: 10),
                    _buildTextField(phoneController, "Phone Number"),
                    const SizedBox(height: 10),
                    _buildTextField(addressController, "Address"),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _logServiceRequest,
                      icon: const Icon(Icons.check),
                      label: const Text("Request this Service"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 254, 197, 8),
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }
}

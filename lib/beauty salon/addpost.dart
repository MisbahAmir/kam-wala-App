import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kam_wala_app/beauty%20salon/postfatechdata.dart';
import 'package:kam_wala_app/dashboard/fatchdata.dart';

class salonPost extends StatefulWidget {
  const salonPost({super.key});

  @override
  State<salonPost> createState() => _salonPostState();
}

class _salonPostState extends State<salonPost> {
  final productController = TextEditingController();
  final descriptionController = TextEditingController();

  /// ✅ Changed from "category" → "saloonCategory"
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref(
    "saloonCategory",
  );

  void addPost() async {
    final title = productController.text.trim();
    final desc = descriptionController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      EasyLoading.showError('All fields are required!');
      return;
    }

    EasyLoading.show(
      status: "Uploading post...",
      maskType: EasyLoadingMaskType.none,
      dismissOnTap: false,
    );

    try {
      final String postId = DateTime.now().microsecondsSinceEpoch.toString();

      await databaseRef.child(postId).set({
        'productName': title,
        'description': desc,
        'createdAt': DateTime.now().toIso8601String(),
      });

      EasyLoading.dismiss();
      EasyLoading.showSuccess("Post Uploaded Successfully!");

      productController.clear();
      descriptionController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const salonFatechdata()),
      );
    } catch (error) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      /// ✅ Changed background to light pink
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '💇 Add Saloon Service',
          style: TextStyle(
            color: Color(0xFFD81B60), // dark pink text
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ✅ Pink gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFEBEE), // very light pink
                  Color(0xFFF8BBD0), // soft pink
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main card with blur effect
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white38),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.2),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset("assets/pic/hairicon1.png", height: 220),
                      const SizedBox(height: 20),
                      const Text(
                        "Enter Saloon Service Details",
                        style: TextStyle(
                          color: Color(0xFFD81B60), // dark pink
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 25),

                      _glassTextField(
                        controller: productController,
                        hint: "Service Name",
                        icon: Icons.cut,
                        color: Colors.pinkAccent,
                      ),
                      const SizedBox(height: 18),

                      _glassTextField(
                        controller: descriptionController,
                        hint: "Description",
                        icon: Icons.description,
                        color: Colors.pink,
                      ),
                      const SizedBox(height: 35),

                      _glowButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return TextField(
      controller: controller,
      cursorColor: color,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        prefixIcon: Icon(icon, color: color),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: color.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: color, width: 1.5),
        ),
      ),
    );
  }

  Widget _glowButton() {
    return GestureDetector(
      onTap: addPost,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF48FB1), // light pink
              Color(0xFFD81B60), // deep pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(
          child: Text(
            "💅 Upload Service",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ EasyLoading pink theme
void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..maskType = EasyLoadingMaskType.none
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorSize = 45.0
    ..radius = 12.0
    ..progressColor = Colors.pink
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.pink
    ..textColor = Colors.pink
    ..userInteractions = true;
}

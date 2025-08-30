import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kam_wala_app/user/user_panel.dart';
import 'package:kam_wala_app/worker/WorkerPanel.dart';

class HomeServiceScreenworker extends StatelessWidget {
  const HomeServiceScreenworker({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ Screen dimensions
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F0FF), Color(0xFFF4F6F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // 🔔 Notification Icon
            Positioned(
              top: size.height * 0.06, // ✅ Responsive spacing
              right: size.width * 0.05,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPanel()),
                  );
                },
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.001),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.25),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.black87,
                            size: size.width * 0.08,
                          ),
                        ),
                        Positioned(
                          right: -4,
                          top: -1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.5),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 5,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: size.width * 0.015),
                    Text(
                      'Notifications',
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Circle
                      Container(
                        width: size.width * 0.85,
                        height: size.width * 0.85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.blue.shade100.withOpacity(0.5),
                              Colors.transparent,
                            ],
                            radius: 0.85,
                            center: Alignment.center,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100.withOpacity(0.4),
                              blurRadius: 180,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.home_filled,
                          size: size.width * 0.65,
                          color: const Color.fromARGB(
                            255,
                            249,
                            250,
                            251,
                          ).withOpacity(0.4),
                        ),
                      ),

                      // Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size.width * 0.5),
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 247, 245, 245),
                              Colors.grey.shade100,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 35,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(size.width * 0.5),
                          child: Image.asset(
                            'assets/pic/happy man.png',
                            width: size.width * 0.65,
                            height: size.height * 0.45,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Text Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Reliable",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.09,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal.shade400,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Home Services",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.blueGrey.shade900,
                            shadows: [
                              const Shadow(
                                blurRadius: 4.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          "Book trusted professionals for cleaning, repairs, and more — anytime, anywhere.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                            height: 1.8,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Button
            Positioned(
              bottom: size.height * 0.04,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorkerPanel()),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(size.width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: size.width * 0.1,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

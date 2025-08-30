import 'package:flutter/material.dart';
import 'package:kam_wala_app/Auth/login_screen.dart';
import 'package:kam_wala_app/Auth/signup_screen.dart';
import 'dart:ui'; // For blur filter

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image Section
            Expanded(
              flex: 8,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pic/map.png'),

                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 15,
                    sigmaY: 15,
                  ), // Glass blur effect
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(
                            255,
                            148,
                            190,
                            249,
                          ).withOpacity(0.85),
                          const Color.fromARGB(
                            255,
                            76,
                            157,
                            237,
                          ).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            81,
                            145,
                            240,
                          ).withOpacity(0.4),
                          offset: Offset(0, -5),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Unlock Possibilities with Kaam Wala App",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.3,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 6.0,
                                color: Colors.blue.shade900.withOpacity(0.9),
                              ),
                              Shadow(
                                offset: Offset(-1, -1),
                                blurRadius: 4.0,
                                color: Colors.blue.shade400.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 35),

                        // Register Button - Gradient with glow
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen1(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.app_registration,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            elevation: 10,
                            shadowColor: Colors.blueAccent.withOpacity(0.7),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: null, // Needed for gradient below
                          ).copyWith(
                            // Add gradient background using MaterialStateProperty
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color?>(
                                  (states) => null,
                                ),
                            // We'll override the button's decoration below
                          ),
                        ),

                        SizedBox(height: 25),

                        // Login Button - Outline with glow and icon
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen1(),
                              ),
                            );
                          },
                          icon: Icon(Icons.login, color: Colors.white),
                          label: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 5.0,
                                  color: Colors.blue.shade900.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 55),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.85),
                              width: 2.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ],
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

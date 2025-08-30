// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kam_wala_app/Admin/Adminpanel.dart';
// import 'package:kam_wala_app/screens/ResetPassword.dart';
// import 'package:kam_wala_app/screens/main_screen.dart';

// import 'package:google_fonts/google_fonts.dart';

// import 'package:kam_wala_app/worker/worker_registration.dart';

// class LoginScreen1 extends StatefulWidget {
//   const LoginScreen1({super.key});
//   @override
//   State<LoginScreen1> createState() => _LoginScreen1State();
// }

// class _LoginScreen1State extends State<LoginScreen1>
//     with SingleTickerProviderStateMixin {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _loading = false;

//   late AnimationController _iconController;
//   late Animation<double> _iconAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _iconController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat(reverse: true);
//     _iconAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
//       CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _iconController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter email and password")),
//       );
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       UserCredential userCred = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(userCred.user!.uid).get();

//       if (!userDoc.exists) {
//         throw Exception("User data not found");
//       }

//       String role = userDoc['role']?.toString().toLowerCase() ?? '';

//       if (role == 'admin') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminPanel()),
//         );
//       } else if (role == 'worker') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => WorkerRegistrationPage()),
//         );
//       } else if (role == 'user') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => HomeServiceScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Role not recognized")));
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   InputDecoration _neumorphicInputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: GoogleFonts.poppins(
//         color: const Color(0xFF1565C0),
//         fontWeight: FontWeight.w600,
//         fontSize: 16,
//       ),
//       prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
//       filled: true,
//       fillColor: Colors.white.withOpacity(0.8),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2.5),
//       ),
//       contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Gradient background
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 234, 235, 236),
//               Color.fromARGB(255, 93, 158, 255),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(30),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.25),
//                         width: 1.5,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.2),
//                           blurRadius: 30,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(32),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AnimatedBuilder(
//                           animation: _iconAnimation,
//                           builder: (context, child) {
//                             return Transform.translate(
//                               offset: Offset(0, -_iconAnimation.value),
//                               child: child,
//                             );
//                           },
//                           child: SizedBox(
//                             height: 160,
//                             width: 500,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color.fromARGB(
//                                       255,
//                                       230,
//                                       238,
//                                       242,
//                                     ).withOpacity(0.3),
//                                     blurRadius: 20,
//                                     spreadRadius: 5,
//                                     offset: const Offset(0, 8),
//                                   ),
//                                 ],
//                                 border: Border.all(
//                                   color: Colors.lightBlue.shade100,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Image.asset(
//                                   'assets/pic/mechanic.png',
//                                   width: double.infinity,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 28),

//                         // Moved "Welcome Back" Text here inside the Column (correct place)
//                         Text(
//                           'Welcome Back',
//                           style: GoogleFonts.poppins(
//                             fontSize: 34,
//                             fontWeight: FontWeight.w900,
//                             color: const Color.fromARGB(
//                               255,
//                               5,
//                               5,
//                               5,
//                             ).withOpacity(0.9),
//                             letterSpacing: 1.3,
//                           ),
//                         ),

//                         const SizedBox(height: 36),

//                         // Email with Neumorphic shadow container
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: Colors.white.withOpacity(0.85),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.shade200.withOpacity(0.5),
//                                 offset: const Offset(6, 6),
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                               ),
//                               BoxShadow(
//                                 color: Colors.white.withOpacity(0.9),
//                                 offset: const Offset(-6, -6),
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: _neumorphicInputDecoration(
//                               'Email',
//                               Icons.email_outlined,
//                             ),
//                             style: GoogleFonts.poppins(
//                               color: const Color(0xFF0D47A1),
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 28),

//                         // Password with Neumorphic shadow container
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: Colors.white.withOpacity(0.85),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.shade200.withOpacity(0.5),
//                                 offset: const Offset(6, 6),
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                               ),
//                               BoxShadow(
//                                 color: Colors.white.withOpacity(0.9),
//                                 offset: const Offset(-6, -6),
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _passwordController,
//                             obscureText: true,
//                             decoration: _neumorphicInputDecoration(
//                               'Password',
//                               Icons.lock_outline,
//                             ),
//                             style: GoogleFonts.poppins(
//                               color: const Color(0xFF0D47A1),
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 12),

//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const ResetPasswordScreen(),
//                                 ),
//                               );
//                             },
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                               ),
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: Text(
//                               'Forgot Password?',
//                               style: GoogleFonts.poppins(
//                                 color: const Color.fromARGB(
//                                   255,
//                                   254,
//                                   87,
//                                   49,
//                                 ).withOpacity(0.85),
//                                 fontWeight: FontWeight.w700,
//                                 decoration: TextDecoration.underline,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 36),

//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white.withOpacity(0.85),
//                               shadowColor: Colors.blue.shade100,
//                               elevation: 18,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             onPressed: _loading ? null : _login,
//                             child:
//                                 _loading
//                                     ? const SizedBox(
//                                       width: 28,
//                                       height: 28,
//                                       child: CircularProgressIndicator(
//                                         color: Color(0xFF0D47A1),
//                                         strokeWidth: 3.5,
//                                       ),
//                                     )
//                                     : Text(
//                                       'Login',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w900,
//                                         letterSpacing: 1.3,
//                                         color: const Color(0xFF0D47A1),
//                                       ),
//                                     ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kam_wala_app/Admin/Adminpanel.dart';
import 'package:kam_wala_app/dashboard/admin_home.dart';
import 'package:kam_wala_app/screens/ResetPassword.dart';
import 'package:kam_wala_app/screens/main_screen.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:kam_wala_app/worker/worker_registration.dart';

class LoginScreen1 extends StatefulWidget {
  const LoginScreen1({super.key});
  @override
  State<LoginScreen1> createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = false;

  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _iconAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userCred.user!.uid).get();

      if (!userDoc.exists) {
        throw Exception("User data not found");
      }

      String role = userDoc['role']?.toString().toLowerCase() ?? '';

      if (role == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdminHomePage()),
        );
      } else if (role == 'worker') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WorkerRegistrationPage()),
        );
      } else if (role == 'user') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeServiceScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Role not recognized")));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _neumorphicInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: const Color(0xFF1565C0),
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          // Gradient background
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 234, 235, 236),
                  Color.fromARGB(255, 93, 158, 255),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 36,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _iconAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, -_iconAnimation.value),
                                  child: child,
                                );
                              },
                              child: SizedBox(
                                height: 160,
                                width: 500,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          230,
                                          238,
                                          242,
                                        ).withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.lightBlue.shade100,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/pic/mechanic.png',
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Moved "Welcome Back" Text here inside the Column (correct place)
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.poppins(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: const Color.fromARGB(
                                  255,
                                  5,
                                  5,
                                  5,
                                ).withOpacity(0.9),
                                letterSpacing: 1.3,
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Email with Neumorphic shadow container
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.85),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200.withOpacity(
                                      0.5,
                                    ),
                                    offset: const Offset(6, 6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    offset: const Offset(-6, -6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _neumorphicInputDecoration(
                                  'Email',
                                  Icons.email_outlined,
                                ),
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF0D47A1),
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Password with Neumorphic shadow container
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.85),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200.withOpacity(
                                      0.5,
                                    ),
                                    offset: const Offset(6, 6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    offset: const Offset(-6, -6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: _neumorphicInputDecoration(
                                  'Password',
                                  Icons.lock_outline,
                                ),
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF0D47A1),
                                  fontSize: 17,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const ResetPasswordScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(
                                      255,
                                      254,
                                      87,
                                      49,
                                    ).withOpacity(0.85),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.85,
                                  ),
                                  shadowColor: Colors.blue.shade100,
                                  elevation: 18,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _loading ? null : _login,
                                child:
                                    _loading
                                        ? const SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF0D47A1),
                                            strokeWidth: 3.5,
                                          ),
                                        )
                                        : Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.3,
                                            color: const Color(0xFF0D47A1),
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

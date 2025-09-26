// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:kam_wala_app/screens/wellcomescreen.dart';
// import 'package:kam_wala_app/services/auth_service.dart';

// class SignupScreen1 extends StatefulWidget {
//   const SignupScreen1({super.key});

//   @override
//   State<SignupScreen1> createState() => _SignupScreen1State();
// }

// class _SignupScreen1State extends State<SignupScreen1>
//     with SingleTickerProviderStateMixin {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   String _selectedRole = "user";
//   final List<String> _roles = ["worker", "user"];

//   final AuthService _authService = AuthService();
//   bool _loading = false;

//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _signup() async {
//     setState(() => _loading = true);
//     var user = await _authService.signupWithRole(
//       name: _nameController.text.trim(),
//       phone: _phoneController.text.trim(),
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//       role: _selectedRole,
//     );
//     setState(() => _loading = false);

//     if (user != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.all(16),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           content: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 66, 245, 96),
//                   Color.fromARGB(255, 13, 161, 107),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.25),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: const [
//                 Icon(Icons.check_circle, color: Colors.white, size: 28),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Signup Successful 🎉",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.all(16),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           content: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Colors.redAccent, Colors.deepOrange],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.25),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: const [
//                 Icon(Icons.error, color: Colors.white, size: 28),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Signup Failed ❌",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final iconList = [Icons.person, Icons.phone, Icons.email, Icons.lock];

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 183, 223, 255),
//               Color.fromARGB(255, 36, 115, 232),
//               Color.fromARGB(255, 254, 255, 255),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               /// 🔙 Back Button
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => const WelcomeScreen()),
//                     );
//                   },
//                 ),
//               ),

//               /// Main Scroll View
//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 60),

//                     /// 🎨 Top Circle with animated icons
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           height: 260,
//                           width: 260,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: RadialGradient(
//                               colors: [
//                                 Color.fromARGB(255, 181, 215, 242),
//                                 Color.fromARGB(255, 66, 126, 245),
//                                 Color.fromARGB(255, 254, 255, 255),
//                               ],
//                               center: Alignment.center,
//                               radius: 0.9,
//                             ),
//                           ),
//                         ),
//                         ClipOval(
//                           child: Image.asset(
//                             "assets/pic/Untitled design (1).png",
//                             height: 200,
//                             width: 200,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         ...List.generate(iconList.length, (index) {
//                           return AnimatedBuilder(
//                             animation: _controller,
//                             builder: (_, __) {
//                               double angle =
//                                   (_controller.value * 2 * pi) +
//                                   (index * pi / 2);
//                               return Transform.translate(
//                                 offset: Offset(
//                                   110 * cos(angle),
//                                   110 * sin(angle),
//                                 ),
//                                 child: CircleAvatar(
//                                   radius: 20,
//                                   backgroundColor: Colors.white,
//                                   child: Icon(
//                                     iconList[index],
//                                     color: Colors.blueAccent,
//                                     size: 22,
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         }),
//                       ],
//                     ),

//                     const SizedBox(height: 40),

//                     /// Title
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.person_add, size: 34, color: Colors.white),
//                         SizedBox(width: 10),
//                         Text(
//                           "Sign Up Your Account First",
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white,
//                             letterSpacing: 1.5,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),

//                     /// 📦 Form Container
//                     Container(
//                       margin: const EdgeInsets.all(20),
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color.fromARGB(255, 255, 255, 255),
//                             Color.fromARGB(255, 220, 240, 255),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(28),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blueAccent.withOpacity(0.2),
//                             blurRadius: 18,
//                             spreadRadius: 2,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           /// Full Name
//                           TextField(
//                             controller: _nameController,
//                             decoration: InputDecoration(
//                               labelText: "Full Name",
//                               prefixIcon: const Icon(
//                                 Icons.person,
//                                 color: Colors.blueAccent,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 18),

//                           /// Phone Number
//                           TextField(
//                             controller: _phoneController,
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(
//                               labelText: "Phone Number",
//                               prefixIcon: const Icon(
//                                 Icons.phone,
//                                 color: Colors.blueAccent,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 18),

//                           /// Email
//                           TextField(
//                             controller: _emailController,
//                             decoration: InputDecoration(
//                               labelText: "Email",
//                               prefixIcon: const Icon(
//                                 Icons.email_outlined,
//                                 color: Colors.blueAccent,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 18),

//                           /// Password
//                           TextField(
//                             controller: _passwordController,
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               labelText: "Password",
//                               prefixIcon: const Icon(
//                                 Icons.lock_outline,
//                                 color: Colors.blueAccent,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 18),

//                           /// Role Dropdown
//                           DropdownButtonFormField<String>(
//                             value: _selectedRole,
//                             decoration: InputDecoration(
//                               labelText: "Select Role",
//                               prefixIcon: const Icon(
//                                 Icons.people,
//                                 color: Colors.blueAccent,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                             items:
//                                 _roles.map((role) {
//                                   return DropdownMenuItem<String>(
//                                     value: role,
//                                     child: Text(role.toUpperCase()),
//                                   );
//                                 }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedRole = value!;
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 28),

//                           _loading
//                               ? const CircularProgressIndicator()
//                               : ElevatedButton(
//                                 onPressed: _signup,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blueAccent,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(40),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 70,
//                                     vertical: 16,
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Create Account",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 35),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kam_wala_app/screens/wellcomescreen.dart';
import 'package:kam_wala_app/services/auth_service.dart';

class SignupScreen1 extends StatefulWidget {
  const SignupScreen1({super.key});

  @override
  State<SignupScreen1> createState() => _SignupScreen1State();
}

class _SignupScreen1State extends State<SignupScreen1>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = "user";
  final List<String> _roles = ["worker", "user"];

  final AuthService _authService = AuthService();
  bool _loading = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    setState(() => _loading = true);
    var user = await _authService.signupWithRole(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
    );
    setState(() => _loading = false);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 66, 245, 96),
                  Color.fromARGB(255, 13, 161, 107),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Signup Successful 🎉",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.error, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Signup Failed ❌",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ screen size
    final iconList = [Icons.person, Icons.phone, Icons.email, Icons.lock];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 183, 223, 255),
              Color.fromARGB(255, 36, 115, 232),
              Color.fromARGB(255, 254, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        /// 🔙 Back Button
                        Positioned(
                          top: 10,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WelcomeScreen(),
                                ),
                              );
                            },
                          ),
                        ),

                        /// Main content
                        Column(
                          children: [
                            SizedBox(height: size.height * 0.08),

                            /// 🎨 Top Circle with animated icons
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: size.width * 0.6,
                                  width: size.width * 0.6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Color.fromARGB(255, 181, 215, 242),
                                        Color.fromARGB(255, 66, 126, 245),
                                        Color.fromARGB(255, 254, 255, 255),
                                      ],
                                      center: Alignment.center,
                                      radius: 0.9,
                                    ),
                                  ),
                                ),
                                ClipOval(
                                  child: Image.asset(
                                    "assets/pic/Untitled design (1).png",
                                    height: size.width * 0.45,
                                    width: size.width * 0.45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                ...List.generate(iconList.length, (index) {
                                  return AnimatedBuilder(
                                    animation: _controller,
                                    builder: (_, __) {
                                      double angle =
                                          (_controller.value * 2 * pi) +
                                          (index * pi / 2);
                                      return Transform.translate(
                                        offset: Offset(
                                          (size.width * 0.3) * cos(angle),
                                          (size.width * 0.3) * sin(angle),
                                        ),
                                        child: CircleAvatar(
                                          radius: size.width * 0.06,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            iconList[index],
                                            color: Colors.blueAccent,
                                            size: size.width * 0.05,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ],
                            ),

                            SizedBox(height: size.height * 0.05),

                            /// Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.follow_the_signs_outlined,
                                  size: size.width * 0.09,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    "Sign Up Your Account First",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: size.width * 0.065,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: size.height * 0.04),

                            /// 📦 Form Container
                            Container(
                              margin: const EdgeInsets.all(20),
                              padding: EdgeInsets.all(size.width * 0.06),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 255, 255, 255),
                                    Color.fromARGB(255, 220, 240, 255),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: _inputDecoration(
                                      "Full Name",
                                      Icons.person,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: _inputDecoration(
                                      "Phone Number",
                                      Icons.phone,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  TextField(
                                    controller: _emailController,
                                    decoration: _inputDecoration(
                                      "Email",
                                      Icons.email_outlined,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: _inputDecoration(
                                      "Password",
                                      Icons.lock_outline,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedRole,
                                    decoration: _inputDecoration(
                                      "Select Role",
                                      Icons.people,
                                    ),
                                    items:
                                        _roles.map((role) {
                                          return DropdownMenuItem<String>(
                                            value: role,
                                            child: Text(role.toUpperCase()),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRole = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.04),
                                  _loading
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                        onPressed: _signup,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.2,
                                            vertical: size.height * 0.02,
                                          ),
                                        ),
                                        child: Text(
                                          "Create Account",
                                          style: TextStyle(
                                            fontSize: size.width * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kam_wala_app/beauty%20salon/salon%20product%20list.dart';

/// ========================= ENHANCED WELCOME SCREEN =========================
class WelcomeScreenuser extends StatefulWidget {
  const WelcomeScreenuser({super.key});

  @override
  State<WelcomeScreenuser> createState() => _WelcomeScreenuserState();
}

class _WelcomeScreenuserState extends State<WelcomeScreenuser>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE6EB), Color(0xFFFFF5F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ----------------- Animated Hero Icon -----------------
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.shade200.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade200, Colors.pink.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.spa,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// ----------------- Title -----------------
                Text(
                  "Welcome to Beauty Hub",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                /// ----------------- Subtitle -----------------
                Text(
                  "Discover top salons & services\njust for you",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.pink.shade400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                /// ----------------- Stylish Button -----------------
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 10,
                    shadowColor: Colors.pinkAccent.withOpacity(0.5),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SalonProductsList(),
                      ),
                    );
                  },
                  child: const Text(
                    "✨ Explore Salons ✨",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:kam_wala_app/beauty%20salon/salon%20product%20list.dart';

// /// ========================= ENHANCED WELCOME SCREEN =========================
// class WelcomeScreenuser extends StatefulWidget {
//   const WelcomeScreenuser({super.key});

//   @override
//   State<WelcomeScreenuser> createState() => _WelcomeScreenuserState();
// }

// class _WelcomeScreenuserState extends State<WelcomeScreenuser>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeIn;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           /// 🌸 Animated Gradient Background
//           AnimatedContainer(
//             duration: const Duration(seconds: 5),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.pink.shade50,
//                   Colors.pink.shade100,
//                   Colors.white,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),

//           /// 🌟 Main Content
//           SafeArea(
//             child: FadeTransition(
//               opacity: _fadeIn,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     /// App Logo / Icon
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.pink.shade100,
//                             blurRadius: 20,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.spa,
//                         size: 100,
//                         color: Colors.pink.shade400,
//                       ),
//                     ),
//                     const SizedBox(height: 40),

//                     /// Title
//                     Text(
//                       "✨ Welcome to Beauty Hub ✨",
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.pink.shade700,
//                         letterSpacing: 1.5,
//                         shadows: [
//                           Shadow(color: Colors.pink.shade200, blurRadius: 10),
//                         ],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),

//                     /// Subtitle
//                     Text(
//                       "Discover the best salons & services near you",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.pink.shade500,
//                         fontStyle: FontStyle.italic,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 60),

//                     /// Glowing Button
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink.shade400,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 60,
//                           vertical: 18,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(35),
//                         ),
//                         elevation: 10,
//                         shadowColor: Colors.pink.shade200,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SalonProductsList(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Explore Products →",
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

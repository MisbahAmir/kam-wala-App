// import 'package:flutter/material.dart';
// import 'package:kam_wala_app/Auth/login_screen.dart';
// import 'package:kam_wala_app/beauty%20salon/salon_user_ui.dart';
// import 'package:kam_wala_app/image%20crud%20hamdeling/imagedatafatech.dart';
// import 'package:kam_wala_app/user/bussinesformscreen.dart';

// class Home3Screen extends StatelessWidget {
//   const Home3Screen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true, // Full page coverage
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           "Preview This App",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 0, 49, 134),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color.fromARGB(255, 0, 49, 134),
//           ),
//           onPressed:
//               () => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen1()),
//               ),
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 201, 218, 244),
//               Color.fromARGB(255, 164, 214, 255),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 80),

//               // ✅ Welcome Section
//               TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0, end: 1),
//                 duration: const Duration(milliseconds: 1000),
//                 curve: Curves.easeInOut,
//                 builder:
//                     (context, value, child) => Opacity(
//                       opacity: value,
//                       child: Transform.translate(
//                         offset: Offset(0, (1 - value) * 20),
//                         child: child,
//                       ),
//                     ),
//                 child: const Text(
//                   "✨ Welcome to KaamWala ✨",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 0, 49, 134),
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 35),

//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 childAspectRatio: 0.9,
//                 children: [
//                   _animatedCard(
//                     delay: 300,
//                     child: _buildServiceCard(
//                       context,
//                       title: "     Handy man ",
//                       img: "assets/pic/22.png",
//                       imgHeight: 140,
//                       imgWidth: 120,
//                       route: FatchAllimage(), // ✅ replaced onPressed with route
//                     ),
//                   ),
//                   _animatedCard(
//                     delay: 600,
//                     child: _buildServiceCard(
//                       context,
//                       title: "Book Appointment",
//                       img: "assets/pic/hair-dye-brush.png",
//                       imgHeight: 140,
//                       imgWidth: 120,
//                       route:
//                           WelcomeScreenuser(), // ✅ replaced onPressed with route
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 30),

//               _animatedCard(
//                 delay: 1000,
//                 child: _buildBusinessCard(
//                   context,
//                   title: "Business With Kaamwala",
//                   img: "assets/pic/thums up.webp",
//                   tags: const ["COMMERCIAL"],
//                   route:
//                       BusinessFormScreen(), // ✅ use route instead of onPressed
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ✅ Fade + Slide Animation Wrapper
//   Widget _animatedCard({required int delay, required Widget child}) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: 1),
//       duration: Duration(milliseconds: 800),
//       curve: Curves.easeOut,
//       builder:
//           (context, value, _) => Opacity(
//             opacity: value,
//             child: Transform.translate(
//               offset: Offset(0, (1 - value) * 30), // Slide up while fading
//               child: child,
//             ),
//           ),
//     );
//   }

//   // ✅ Service Card Widget with adjustable image size
//   Widget _buildServiceCard(
//     BuildContext context, {
//     required String title,
//     required String img,
//     required double imgHeight,
//     required double imgWidth,
//     required Widget route,
//   }) {
//     return GestureDetector(
//       onTap:
//           () =>
//               Navigator.push(context, MaterialPageRoute(builder: (_) => route)),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.blue.shade50],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 8,
//               offset: const Offset(2, 4),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.blue.shade900,
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Image.asset(
//                 img,
//                 fit: BoxFit.contain,
//                 width: imgWidth,
//                 height: imgHeight,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ Business Card Widget
//   Widget _buildBusinessCard(
//     BuildContext context, {
//     required String title,
//     required String img,
//     required List<String> tags,
//     required Widget route,
//   }) {
//     return GestureDetector(
//       onTap:
//           () =>
//               Navigator.push(context, MaterialPageRoute(builder: (_) => route)),
//       child: Container(
//         height: 190,
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.blue.shade100],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 12,
//               offset: const Offset(3, 6),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(18),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 6),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 26,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Wrap(
//                     spacing: 6,
//                     children:
//                         tags
//                             .map(
//                               (t) => Chip(
//                                 label: Text(
//                                   t,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 backgroundColor: Colors.blue.shade600,
//                               ),
//                             )
//                             .toList(),
//                   ),
//                 ],
//               ),
//             ),

//             // Expanded(
//             //   flex: 1,
//             //   child: Align(
//             //     alignment: Alignment.centerRight,
//             //     child: Image.asset(img, fit: BoxFit.contain, height: 200),
//             //   ),
//             // ),
//             Expanded(
//               flex: 1,
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Image.asset(
//                   img,
//                   fit: BoxFit.contain,
//                   height:
//                       MediaQuery.of(context).size.height *
//                       0.25, // 25% of screen height
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:kam_wala_app/Auth/login_screen.dart';
import 'package:kam_wala_app/beauty%20salon/salon_user_ui.dart';
import 'package:kam_wala_app/image%20crud%20hamdeling/imagedatafatech.dart';
import 'package:kam_wala_app/user/bussinesformscreen.dart';

class Home3Screen extends StatelessWidget {
  const Home3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Preview This App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmall ? 16 : 20,
            color: const Color.fromARGB(255, 0, 49, 134),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 0, 49, 134),
          ),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen1()),
              ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 201, 218, 244),
              Color.fromARGB(255, 164, 214, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmall ? 12 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),

              // ✅ Welcome Section
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                builder:
                    (context, value, child) => Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    ),
                child: Text(
                  "✨ Welcome to KaamWala ✨",
                  style: TextStyle(
                    fontSize: isSmall ? 20 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 49, 134),
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ✅ Always 2 Cards (Responsive Grid)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 🔥 Always 2 per row
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isSmall ? 0.8 : 0.9,
                children: [
                  _animatedCard(
                    delay: 300,
                    child: _buildServiceCard(
                      context,
                      title: "     Handy man ",
                      img: "assets/pic/22.png",
                      imgHeight: isSmall ? 90 : 120,
                      imgWidth: isSmall ? 80 : 110,
                      route: FatchAllimage(),
                    ),
                  ),
                  _animatedCard(
                    delay: 600,
                    child: _buildServiceCard(
                      context,
                      title: "Book Appointment",
                      img: "assets/pic/iconappointment.jpg",
                      imgHeight: isSmall ? 90 : 120,
                      imgWidth: isSmall ? 80 : 110,
                      route: WelcomeScreenuser(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _animatedCard(
                delay: 1000,
                child: _buildBusinessCard(
                  context,
                  title: "Business With Kaamwala",
                  img: "assets/pic/thums up.webp",
                  tags: const ["COMMERCIAL"],
                  route: BusinessFormScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Fade + Slide Animation
  Widget _animatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder:
          (context, value, _) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 30),
              child: child,
            ),
          ),
    );
  }

  // ✅ Service Card
  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String img,
    required double imgHeight,
    required double imgWidth,
    required Widget route,
  }) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return GestureDetector(
      onTap:
          () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => route)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 15 : 18,
                color: Colors.blue.shade900,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                img,
                fit: BoxFit.contain,
                width: imgWidth,
                height: imgHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Business Card
  Widget _buildBusinessCard(
    BuildContext context, {
    required String title,
    required String img,
    required List<String> tags,
    required Widget route,
  }) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return GestureDetector(
      onTap:
          () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => route)),
      child: Container(
        height: isSmall ? 160 : 190,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(3, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: isSmall ? 18 : 24,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children:
                        tags
                            .map(
                              (t) => Chip(
                                label: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: isSmall ? 10 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.blue.shade600,
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  img,
                  fit: BoxFit.contain,
                  height: size.height * 0.22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

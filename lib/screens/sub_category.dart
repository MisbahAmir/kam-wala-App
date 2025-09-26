import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kam_wala_app/dashboard/imagedatafatech.dart';
import 'package:kam_wala_app/image%20crud%20hamdeling/imagedatafatech.dart';

import 'package:shimmer/shimmer.dart'; // for blur effect

class SubCategoryLongScreen extends StatefulWidget {
  const SubCategoryLongScreen({super.key});

  @override
  State<SubCategoryLongScreen> createState() => _SubCategoryLongScreenState();
}

class _SubCategoryLongScreenState extends State<SubCategoryLongScreen> {
  final int _selectedIndex = 1;

  final List<String> serviceImages = [
    'assets/pic/male-plumber.jpg',

    'assets/pic/technichian.jpg',
    'assets/pic/Services Banner.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true, // for curved navbar overlay
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F0FF), Color(0xFFF4F6F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // _buildBannerSearch(),
                // const SizedBox(height: 50),
                _buildCarousel(),
                const SizedBox(height: 30),
                _buildHeading(),
                const SizedBox(height: 40),
                _buildServiceIcons(),
                const SizedBox(height: 50),
                _buildWhyChooseUs(),
                const SizedBox(height: 10),
                _buildCallToAction(),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // 🔥 Modern Curved Bottom Navigation Bar
      // bottomNavigationBar: _buildCurvedNavBar(),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items:
          serviceImages.map((imagePath) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Text(
          //   "Explore Our Premium Services",
          //   style: GoogleFonts.poppins(
          //     fontSize: 28,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.blueGrey.shade900,
          //     letterSpacing: 1.2,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          Shimmer.fromColors(
            // baseColor: Colors.blueGrey.shade900,
            baseColor: Colors.lightBlueAccent.shade100,
            highlightColor: Colors.blueGrey.shade900,
            period: const Duration(seconds: 2), // smooth speed
            child: Text(
              " Explore Our Premium Services",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: Colors.blueGrey.shade200.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "From plumbing and AC repair to deep cleaning — we bring trust, skill, and care to your doorstep.",
            style: GoogleFonts.openSans(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800.withOpacity(0.9),
              height: 1.6,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: 2.5, // ✅ box ko slim aur modern banaya
        children: [
          _buildImageCard(
            "assets/pic/user profile.jpg",
            "View & Book All Services",
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath, String title) {
    return StatefulBuilder(
      builder: (context, setState) {
        double scale = 1.0;
        return GestureDetector(
          onTapDown: (_) => setState(() => scale = 0.95),
          onTapUp: (_) => setState(() => scale = 1.0),
          onTapCancel: () => setState(() => scale = 1.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FatchAllimage()),
            );
          },
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(18),
                    ),
                    child: Image.asset(
                      imagePath,
                      height: double.infinity, // ✅ image full height
                      width: 150, // ✅ fix width for modern look
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                    // Text(
                    //   title,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.cyanAccent,
                    //   ),
                    // ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF00C9FF),
                                  Color.fromARGB(255, 8, 8, 8),
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWhyChooseUs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✨ Animated Heading
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * -20),
                  child: child,
                ),
              );
            },
            child: Text(
              "Why Choose Us?",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.blue.shade700,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 20),

          _buildInfoPoint(
            Icons.verified_rounded,
            "Verified & Experienced Professionals",
          ),
          _buildInfoPoint(
            Icons.schedule_rounded,
            "Instant Booking & On-time Service",
          ),
          _buildInfoPoint(
            Icons.attach_money_rounded,
            "Transparent Pricing & Support",
          ),
          _buildInfoPoint(
            Icons.emoji_emotions_rounded,
            "Satisfaction Guaranteed",
          ),

          const SizedBox(height: 25),

          // 🌟 Stats Card with Gradient & Glow
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("5000+", "Happy Customers"),
                _buildStat("4.9★", "Average Rating"),
                _buildStat("24/7", "Support"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        // Small pop-in animation for numbers
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Existing Why Choose Us stays same above...

  Widget _buildFeatureCard(IconData icon, String title) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Icon(icon, size: 32, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
  //new

  // 🔹 NEW Stylish Closing Section: Call to Action
  Widget _buildCallToAction() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: Text(
              "Experience the Best Service Today!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Join thousands of happy customers who trust us every day.",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            onPressed: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FatchAllimage()),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(
              "Get Started",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

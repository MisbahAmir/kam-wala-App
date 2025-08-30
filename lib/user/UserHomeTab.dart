import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kam_wala_app/user/BuyToolsScreen.dart';
import 'package:kam_wala_app/user/UserJobsTab.dart';

import 'package:marquee/marquee.dart';

class UserHomeTab extends StatefulWidget {
  const UserHomeTab({super.key});

  @override
  State<UserHomeTab> createState() => _UserHomeTabState();
}

class _UserHomeTabState extends State<UserHomeTab> {
  void logUserClick(String serviceName) {
    FirebaseFirestore.instance.collection('userClicks').add({
      'service': serviceName,
      'timestamp': Timestamp.now(),
    });
  }

  void handleQRScanResult(String result) {
    if (result == "cleaning") {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const CleaningDetailScreen()),
      //   );
      // } else if (result == "electrician") {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const ElectricianDetailScreen()),
      //   );
    } else if (result == "buy_tools") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BuyToolsScreen()),
      );
    }
  }

  Future<void> _startQRScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserJobsTab()),
    );

    if (!mounted || result == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("QR Result"),
              content: Text(result.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
      handleQRScanResult(result.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 108, 107, 107),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Text(
              //   "Welcome to Kaam Wala",
              //   style: GoogleFonts.poppins(
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.yellow,
              //   ),
              // ),
              SizedBox(
                height: 40,
                child: ShaderMask(
                  shaderCallback:
                      (bounds) => const LinearGradient(
                        colors: [Colors.yellow, Colors.orange],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: Marquee(
                    text: "Welcome to Kaam Wala",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // masked by gradient
                      letterSpacing: 1.2,
                    ),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 60,
                    velocity: 40,
                    pauseAfterRound: Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),

              // ShaderMask(
              //   shaderCallback:
              //       (bounds) => LinearGradient(
              //         colors: [Colors.yellow, Colors.orange],
              //       ).createShader(
              //         Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              //       ),
              //   child: Text(
              //      "Get connected with trusted professionals and buy quality tools.",
              //     style: GoogleFonts.poppins(
              //       fontSize: 32,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white, // This will be masked by the gradient
              //       letterSpacing: 1.2,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: Text(
                  "Get connected with trusted professionals and buy quality tools.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // This will be masked by the gradient
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 45),
              _buildServiceCard(
                icon: Icons.cleaning_services,
                title: "Cleaning",
                subtitle: "Hire professional cleaners",
              ),
              _buildServiceCard(
                icon: Icons.electrical_services,
                title: "Electrician",
                subtitle: "Find reliable electricians",
              ),
              _buildServiceCard(
                icon: Icons.shopping_cart_checkout,
                title: "Buy Tools",
                subtitle: "Purchase tools and materials",
                isProduct: true,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _startQRScan,
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    size: 50,
                    color: Colors.black,
                  ),
                  label: const Text("Scan QR for Quick Access"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 18,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isProduct = false,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.yellow,
          child: Icon(icon, color: Colors.black, size: 28),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
        onTap: () {
          logUserClick(title);
          if (title == "Cleaning") {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => const CleaningDetailScreen()),
            //   );
            // } else if (title == "Electrician") {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) => const ElectricianDetailScreen(),
            //     ),
            //   );
          } else if (title == "Buy Tools") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BuyToolsScreen()),
            );
          }
        },
      ),
    );
  }
}

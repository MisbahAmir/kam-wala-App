import 'package:flutter/material.dart';
import 'package:kam_wala_app/dashboard/admin_drawer.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // so background shows behind drawer
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.blue.shade100.withOpacity(0.6),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          leading: IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _ctrl,
              color: Colors.blue.shade900,
              size: 30,
            ),
            splashRadius: 28,
            onPressed: _toggleDrawer,
          ),
          title: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [
                    Colors.blue.shade900,
                    Colors.blueAccent,
                    Colors.cyanAccent.shade200,
                  ],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: const Text(
              'Admin Panel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),

      body: Stack(
        children: [
          // Main welcome content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/pic/kaamwala.png',
                    height: 90,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome, Admin',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.blue.shade200,
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a menu from the left drawer',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Animated drawer sliding over background
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              double slide = 250.0 * _ctrl.value; // drawer width
              return Transform.translate(
                offset: Offset(-250 + slide, 0),
                child: Opacity(
                  opacity: _ctrl.value,
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Admindrawer(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


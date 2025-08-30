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

// import 'package:flutter/material.dart';

// class AnimatedAdminDrawer extends StatelessWidget {
//   final AnimationController controller;
//   final void Function(String key, String title)
//   onMenuTap; // ✅ Menu tap callback

//   const AnimatedAdminDrawer({
//     super.key,
//     required this.controller,
//     required this.onMenuTap,
//   });

//   // Menu items list
//   List<Map<String, dynamic>> get _items => [
//     {
//       'k': 'categories',
//       'icon': Icons.category,
//       'title': 'Manage Categories',
//       'sub': 'Main service categories',
//     },
//     {
//       'k': 'sub_services',
//       'icon': Icons.home_repair_service,
//       'title': 'Sub-Services',
//       'sub': 'Add / edit sub services',
//     },
//     {
//       'k': 'workers',
//       'icon': Icons.people,
//       'title': 'Worker Management',
//       'sub': 'Approve / Block workers',
//     },
//     {
//       'k': 'featured',
//       'icon': Icons.star,
//       'title': 'Featured Services',
//       'sub': 'Highlight top services',
//     },
//     {
//       'k': 'transactions',
//       'icon': Icons.payments,
//       'title': 'Transactions',
//       'sub': 'View payments & payouts',
//     },
//     {
//       'k': 'analytics',
//       'icon': Icons.analytics,
//       'title': 'Reports & Analytics',
//       'sub': 'Earnings & trends',
//     },
//     {
//       'k': 'settings',
//       'icon': Icons.settings,
//       'title': 'Settings',
//       'sub': 'App & platform settings',
//     },
//     {'k': 'logout', 'icon': Icons.logout, 'title': 'Logout', 'sub': 'Sign out'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SizeTransition(
//       sizeFactor: CurvedAnimation(parent: controller, curve: Curves.easeInOut),
//       axisAlignment: -1.0,
//       child: Container(
//         width: 260,
//         color: Colors.white,
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header
//               DrawerHeader(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.blue,
//                       child: Icon(
//                         Icons.admin_panel_settings,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Admin Panel",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text("Welcome Back!"),
//                   ],
//                 ),
//               ),
//               const Divider(),
//               // Menu list
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _items.length,
//                   itemBuilder: (context, index) {
//                     final item = _items[index];
//                     return ListTile(
//                       leading: Icon(item['icon'], color: Colors.blue),
//                       title: Text(item['title']),
//                       subtitle: Text(item['sub']),
//                       onTap: () => onMenuTap(item['k'], item['title']),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

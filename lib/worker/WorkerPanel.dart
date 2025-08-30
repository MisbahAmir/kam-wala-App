// import 'package:flutter/material.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:kam_wala_app/Admin/AdminElectricianRequestsTab.dart';
// import 'package:kam_wala_app/After_Scan_View_files/plumber_detail_screen.dart';
// import 'package:kam_wala_app/After_Scan_View_files/worker_service_requests_tab.dart';
// import 'package:kam_wala_app/Auth/login_screen.dart';
// import 'package:kam_wala_app/feedback/workerfeedbackscreen.dart';
// import 'package:kam_wala_app/screens/sub_category.dart';

// import 'package:kam_wala_app/user/user_panel.dart';
// import 'package:kam_wala_app/worker/WorkerApplicationsTab.dart';
// import 'package:kam_wala_app/worker/WorkerJobsTab.dart';
// import 'package:kam_wala_app/worker/WorkerProfileTab.dart';
// import 'package:kam_wala_app/worker/worker_registration.dart';

// class WorkerPanel extends StatefulWidget {
//   const WorkerPanel({super.key});

//   @override
//   State<WorkerPanel> createState() => _WorkerPanelState();
// }

// class _WorkerPanelState extends State<WorkerPanel> {
//   int _selectedIndex = 0;
//   String _selectedRole = 'Worker';
//   String workerId = "worker123";

//   final List<String> _roles = ['Worker', 'User'];

//   final List<Widget> _pages = [
//     const WorkerRegistrationPage(),
//     const WorkerApplicationsTab(),
//     WorkerFeedbackScreen(workerId: workerId),
//     const WorkerProfileTab(),
//   ];

//   final List<String> _titles = [
//     'Verification',
//     'My Applications',
//     'Feedback',
//     'Profile',
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _logout() {
//     Navigator.pop(context);
//   }

//   void _navigateWithFade(Widget screen) {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => screen,
//         transitionsBuilder: (_, anim, __, child) {
//           return FadeTransition(opacity: anim, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 400),
//       ),
//     );
//   }

//   void _handleRoleChange(String? newValue) {
//     if (newValue == null || newValue == _selectedRole) return;

//     setState(() => _selectedRole = newValue);

//     if (newValue == 'Electrician') {
//       _navigateWithFade(AdminElectricianRequestsTab());
//     } else if (newValue == 'Plumber') {
//       _navigateWithFade(PlumberDetailScreen());
//     } else if (newValue == 'User') {
//       _navigateWithFade(UserPanel());
//     }
//   }

//   Widget _buildMobileView() {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text(
//               _titles[_selectedIndex],
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             DropdownButton<String>(
//               value: _selectedRole,
//               dropdownColor: Colors.blueGrey[900], // was grey[900]
//               icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//               underline: const SizedBox(),
//               onChanged: _handleRoleChange,
//               items:
//                   _roles
//                       .map(
//                         (role) => DropdownMenuItem<String>(
//                           value: role,
//                           child: Text(
//                             role,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//                       .toList(),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen1()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: ConvexAppBar(
//         backgroundColor: Colors.black,
//         activeColor: Colors.blueAccent, // was yellow
//         style: TabStyle.react,
//         items: const [
//           TabItem(icon: Icons.domain_verification, title: 'verification'),
//           TabItem(icon: Icons.assignment, title: 'My Apps'),
//           TabItem(icon: Icons.feedback_outlined, title: 'Feedback'),
//           TabItem(icon: Icons.person, title: 'Profile'),
//         ],
//         initialActiveIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }

//   Widget _buildTabletDesktopView() {
//     return Scaffold(
//       body: Row(
//         children: [
//           NavigationRail(
//             backgroundColor: Colors.blueGrey[900], // was grey[900]
//             selectedIconTheme: const IconThemeData(
//               color: Colors.blueAccent,
//             ), // was yellow
//             unselectedIconTheme: const IconThemeData(color: Colors.white),
//             selectedLabelTextStyle: const TextStyle(
//               color: Colors.blueAccent,
//             ), // was yellow
//             unselectedLabelTextStyle: const TextStyle(color: Colors.white),
//             destinations: const [
//               NavigationRailDestination(
//                 icon: Icon(Icons.work),
//                 label: Text('Jobs'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.assignment),
//                 label: Text('My Apps'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.verified_user_sharp),
//                 label: Text('User Service'),
//               ),
//               NavigationRailDestination(
//                 icon: Icon(Icons.person),
//                 label: Text('Profile'),
//               ),
//             ],
//             selectedIndex: _selectedIndex,
//             onDestinationSelected: _onItemTapped,
//             labelType: NavigationRailLabelType.all,
//             leading: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 const Icon(Icons.person_pin, color: Colors.white),
//                 const SizedBox(height: 16),
//                 DropdownButton<String>(
//                   value: _selectedRole,
//                   dropdownColor: Colors.blueGrey[800], // was grey[800]
//                   icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//                   underline: const SizedBox(),
//                   onChanged: _handleRoleChange,
//                   items:
//                       _roles
//                           .map(
//                             (role) => DropdownMenuItem<String>(
//                               value: role,
//                               child: Text(
//                                 role,
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ],
//             ),
//           ),
//           const VerticalDivider(width: 1),
//           Expanded(
//             child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.black,
//                 title: Text(
//                   '${_titles[_selectedIndex]} ($_selectedRole)',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: const Icon(Icons.logout, color: Colors.white),
//                     onPressed: _logout,
//                   ),
//                 ],
//               ),
//               body: _pages[_selectedIndex],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth < 700) {
//           return _buildMobileView();
//         } else {
//           return _buildTabletDesktopView();
//         }
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:kam_wala_app/Admin/AdminElectricianRequestsTab.dart';
import 'package:kam_wala_app/After_Scan_View_files/plumber_detail_screen.dart';
import 'package:kam_wala_app/feedback/workerfeedbackscreen.dart';
import 'package:kam_wala_app/Auth/login_screen.dart';
import 'package:kam_wala_app/image%20crud%20hamdeling/worker_job_request_screen.dart';
import 'package:kam_wala_app/user/user_panel.dart';
import 'package:kam_wala_app/wallet/Worker_wallet.dart';
import 'package:kam_wala_app/worker/WorkerApplicationsTab.dart';
import 'package:kam_wala_app/worker/WorkerProfileTab.dart';
import 'package:kam_wala_app/worker/worker_registration.dart';

class WorkerPanel extends StatefulWidget {
  const WorkerPanel({super.key});

  @override
  State<WorkerPanel> createState() => _WorkerPanelState();
}

class _WorkerPanelState extends State<WorkerPanel> {
  int _selectedIndex = 0;
  String _selectedRole = 'Worker';
  String workerId = "worker123"; // ✅ define workerId

  final List<String> _roles = ['Worker', 'User'];
  final List<String> _titles = [
    'Verification',
    'Service Requests',
    'wallet',
    'Feedback',
    'Profile',
  ];

  // ❌ Remove class-level _pages
  List<Widget> get _pages {
    // ✅ Initialize pages dynamically here
    return [
      const WorkerRegistrationPage(),
      WorkerJobRequestScreen(workerId: workerId),
      WorkerWallet(),
      WorkerFeedbackScreen(workerId: workerId), // now works
      const WorkerProfileTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pop(context);
  }

  void _navigateWithFade(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _handleRoleChange(String? newValue) {
    if (newValue == null || newValue == _selectedRole) return;

    setState(() => _selectedRole = newValue);

    if (newValue == 'Electrician') {
      _navigateWithFade(AdminElectricianRequestsTab());
    } else if (newValue == 'Plumber') {
      _navigateWithFade(PlumberDetailScreen());
    } else if (newValue == 'User') {
      _navigateWithFade(UserPanel());
    }
  }

  Widget _buildMobileView() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: _selectedRole,
              dropdownColor: Colors.blueGrey[900],
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              onChanged: _handleRoleChange,
              items:
                  _roles
                      .map(
                        (role) => DropdownMenuItem<String>(
                          value: role,
                          child: Text(
                            role,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen1()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.black,
        activeColor: Colors.blueAccent,
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.domain_verification, title: 'Verification'),
          TabItem(icon: Icons.notification_add, title: 'Notification'),

          TabItem(icon: Icons.wallet, title: 'wallet'),
          TabItem(icon: Icons.feedback_outlined, title: 'Feedback'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTabletDesktopView() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.blueGrey[900],
            selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
            unselectedIconTheme: const IconThemeData(color: Colors.white),
            selectedLabelTextStyle: const TextStyle(color: Colors.blueAccent),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.work),
                label: Text('Jobs'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assignment),
                label: Text('wallet'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback_rounded),
                label: Text('feedback'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            leading: Column(
              children: [
                const SizedBox(height: 16),
                const Icon(Icons.person_pin, color: Colors.white),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedRole,
                  dropdownColor: Colors.blueGrey[800],
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: const SizedBox(),
                  onChanged: _handleRoleChange,
                  items:
                      _roles
                          .map(
                            (role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(
                                role,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  '${_titles[_selectedIndex]} ($_selectedRole)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _logout,
                  ),
                ],
              ),
              body: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return _buildMobileView();
        } else {
          return _buildTabletDesktopView();
        }
      },
    );
  }
}

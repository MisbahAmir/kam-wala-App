import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kam_wala_app/Admin/users_profile_view.dart'; // ✅ Import your view screen

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final data = user.data() as Map<String, dynamic>;

            final name = data['name'] ?? 'Unknown';
            final email = data['email'] ?? 'No email';
            final role = data['role'] ?? 'No role';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('$email\nRole: $role'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      tooltip: 'View Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AdminViewUserProfile(userId: user.id),
                          ),
                        );
                      },
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Delete') {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .delete();
                        } else if (value == 'Block') {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .update({'status': 'blocked'});
                        }
                      },
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(value: 'Block', child: Text('Block')),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:kam_wala_app/Admin/users_profile_view.dart'; // ✅ Import your view screen

// class AdminUsersTab extends StatelessWidget {
//   const AdminUsersTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('users').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No users found'));
//         }

//         final users = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             final data = user.data() as Map<String, dynamic>;

//             final name = data['name'] ?? 'Unknown';
//             final email = data['email'] ?? 'No email';
//             final role = data['role'] ?? 'No role';

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: ListTile(
//                 title: Text(
//                   name,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text('$email\nRole: $role'),
//                 isThreeLine: true,
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.visibility, color: Colors.blue),
//                       tooltip: 'View Profile',
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (_) => AdminViewUserProfile(userId: user.id),
//                           ),
//                         );
//                       },
//                     ),
//                     PopupMenuButton<String>(
//                       onSelected: (value) {
//                         if (value == 'Delete') {
//                           FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(user.id)
//                               .delete();
//                         } else if (value == 'Block') {
//                           FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(user.id)
//                               .update({'status': 'blocked'});
//                         }
//                       },
//                       itemBuilder:
//                           (context) => const [
//                             PopupMenuItem(value: 'Block', child: Text('Block')),
//                             PopupMenuItem(
//                               value: 'Delete',
//                               child: Text('Delete'),
//                             ),
//                           ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

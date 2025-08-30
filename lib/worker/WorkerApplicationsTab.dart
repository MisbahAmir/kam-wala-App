// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class WorkerApplicationsTab extends StatelessWidget {
//   const WorkerApplicationsTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return const Center(child: Text('Not logged in'));
//     }

//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection('applications')
//               .where('userId', isEqualTo: currentUser.uid)
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text('Something went wrong while loading your applications'),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final apps = snapshot.data?.docs;

//         if (apps == null || apps.isEmpty) {
//           return const Center(child: Text('No applications yet'));
//         }

//         return ListView.builder(
//           itemCount: apps.length,
//           itemBuilder: (context, index) {
//             final app = apps[index];
//             final jobId = app['jobId'];
//             final timestamp = app['timestamp']?.toDate();

//             return FutureBuilder<DocumentSnapshot>(
//               future:
//                   FirebaseFirestore.instance
//                       .collection('jobs')
//                       .doc(jobId)
//                       .get(),
//               builder: (context, jobSnapshot) {
//                 if (jobSnapshot.connectionState == ConnectionState.waiting) {
//                   return const ListTile(title: Text('Loading job...'));
//                 }

//                 if (!jobSnapshot.hasData || !jobSnapshot.data!.exists) {
//                   return const ListTile(title: Text('Job not found'));
//                 }

//                 final jobData =
//                     jobSnapshot.data!.data() as Map<String, dynamic>;
//                 return ListTile(
//                   title: Text(jobData['title'] ?? 'No title'),
//                   subtitle: Text('Applied on: ${timestamp?.toLocal()}'),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class WorkerApplicationsTab extends StatefulWidget {
//   const WorkerApplicationsTab({super.key});

//   @override
//   State<WorkerApplicationsTab> createState() => _WorkerApplicationsTabState();
// }

// class _WorkerApplicationsTabState extends State<WorkerApplicationsTab> {
//   Future<List<Map<String, dynamic>>> _fetchApplications() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return [];

//     final querySnapshot =
//         await FirebaseFirestore.instance
//             .collection('applications')
//             .where('userId', isEqualTo: user.uid)
//             .orderBy('timestamp', descending: true)
//             .get();

//     List<Map<String, dynamic>> applications = [];

//     for (var doc in querySnapshot.docs) {
//       final data = doc.data();
//       final jobId = data['jobId'];
//       final jobDoc =
//           await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

//       if (jobDoc.exists) {
//         final jobData = jobDoc.data();
//         applications.add({
//           'applicationId': doc.id,
//           'title': jobData?['title'] ?? 'No Title',
//           'company': jobData?['company'] ?? 'Unknown Company',
//           'location': jobData?['location'] ?? 'Unknown Location',
//           'status': data['status'] ?? 'pending',
//           'timestamp': data['timestamp'],
//         });
//       }
//     }

//     return applications;
//   }

//   Future<void> _deleteApplication(String id) async {
//     await FirebaseFirestore.instance
//         .collection('applications')
//         .doc(id)
//         .delete();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: _fetchApplications(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text('Something went wrong while loading your applications'),
//           );
//         }

//         final applications = snapshot.data ?? [];

//         if (applications.isEmpty) {
//           return const Center(child: Text('No applications yet'));
//         }

//         return ListView.builder(
//           itemCount: applications.length,
//           itemBuilder: (context, index) {
//             final app = applications[index];
//             final date = (app['timestamp'] as Timestamp).toDate();

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: ListTile(
//                 leading: const Icon(
//                   Icons.assignment_turned_in,
//                   color: Colors.black,
//                 ),
//                 title: Text(app['title']),
//                 subtitle: Text(
//                   '${app['company']} • ${app['location']}\n'
//                   'Status: ${app['status']} • ${date.toLocal()}',
//                 ),
//                 isThreeLine: true,
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _deleteApplication(app['applicationId']),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamp

class WorkerApplicationsTab extends StatefulWidget {
  const WorkerApplicationsTab({super.key});

  @override
  State<WorkerApplicationsTab> createState() => _WorkerApplicationsTabState();
}

class _WorkerApplicationsTabState extends State<WorkerApplicationsTab> {
  Future<List<Map<String, dynamic>>> _fetchApplications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('applications')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .get();

    List<Map<String, dynamic>> applications = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final jobId = data['jobId'];
      final jobDoc =
          await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

      if (jobDoc.exists) {
        final jobData = jobDoc.data();
        applications.add({
          'applicationId': doc.id,
          'title': jobData?['title'] ?? 'No Title',
          'company': jobData?['company'] ?? 'Unknown Company',
          'location': jobData?['location'] ?? 'Unknown Location',
          'status': data['status'] ?? 'Pending',
          'timestamp': data['timestamp'],
        });
      }
    }

    return applications;
  }

  Future<void> _deleteApplication(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Application'),
            content: const Text(
              'Are you sure you want to cancel this application?',
            ),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(id)
          .delete();
      setState(() {});
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchApplications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.yellow),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong while loading your applications',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final applications = snapshot.data ?? [];

        if (applications.isEmpty) {
          return const Center(
            child: Text(
              'No applications yet',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final app = applications[index];
            final date = (app['timestamp'] as Timestamp).toDate();
            final formattedDate = DateFormat.yMMMMd().add_jm().format(date);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: const Icon(
                  Icons.work_outline,
                  color: Colors.yellow,
                  size: 30,
                ),
                title: Text(
                  app['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${app['company']} • ${app['location']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildStatusBadge(app['status']),
                        const SizedBox(width: 12),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteApplication(app['applicationId']),
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
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class WorkerApplicationsTab extends StatefulWidget {
//   const WorkerApplicationsTab({super.key});

//   @override
//   State<WorkerApplicationsTab> createState() => _WorkerApplicationsTabState();
// }

// class _WorkerApplicationsTabState extends State<WorkerApplicationsTab> {
//   Future<List<Map<String, dynamic>>> _fetchApplications() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return [];

//     final querySnapshot =
//         await FirebaseFirestore.instance
//             .collection('applications')
//             .where('userId', isEqualTo: user.uid)
//             .orderBy('timestamp', descending: true)
//             .get();

//     List<Map<String, dynamic>> applications = [];

//     for (var doc in querySnapshot.docs) {
//       final data = doc.data();
//       final jobId = data['jobId'];
//       final jobDoc =
//           await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

//       if (jobDoc.exists) {
//         final jobData = jobDoc.data();
//         applications.add({
//           'applicationId': doc.id,
//           'title': jobData?['title'] ?? 'No Title',
//           'company': jobData?['company'] ?? 'Unknown Company',
//           'location': jobData?['location'] ?? 'Unknown Location',
//           'status': data['status'] ?? 'pending',
//           'timestamp': data['timestamp'],
//         });
//       }
//     }

//     return applications;
//   }

//   Future<void> _deleteApplication(String id) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Cancel Application'),
//             content: const Text(
//               'Are you sure you want to cancel this application?',
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('No'),
//                 onPressed: () => Navigator.pop(context, false),
//               ),
//               TextButton(
//                 child: const Text('Yes'),
//                 onPressed: () => Navigator.pop(context, true),
//               ),
//             ],
//           ),
//     );

//     if (confirm == true) {
//       await FirebaseFirestore.instance
//           .collection('applications')
//           .doc(id)
//           .delete();
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: _fetchApplications(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text('Something went wrong while loading your applications'),
//           );
//         }

//         final applications = snapshot.data ?? [];

//         if (applications.isEmpty) {
//           return const Center(child: Text('No applications yet'));
//         }

//         return ListView.builder(
//           itemCount: applications.length,
//           itemBuilder: (context, index) {
//             final app = applications[index];
//             final date = (app['timestamp'] as Timestamp).toDate();

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: ListTile(
//                 leading: const Icon(
//                   Icons.assignment_turned_in,
//                   color: Colors.black,
//                 ),
//                 title: Text(app['title']),
//                 subtitle: Text(
//                   '${app['company']} • ${app['location']}\n'
//                   'Status: ${app['status']} • ${date.toLocal()}',
//                 ),
//                 isThreeLine: true,
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _deleteApplication(app['applicationId']),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

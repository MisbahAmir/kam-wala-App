import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminApplicationsTab extends StatelessWidget {
  const AdminApplicationsTab({super.key});

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.exists ? doc.data() ?? {} : {};
  }

  Future<Map<String, dynamic>> _fetchJobData(String jobId) async {
    final doc =
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();
    return doc.exists ? doc.data() ?? {} : {};
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('applications')
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final applications = snapshot.data!.docs;

        if (applications.isEmpty) {
          return const Center(child: Text('No applications found'));
        }

        return ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];
            final jobId = application['jobId'];
            final userId = application['userId'];
            final timestamp = (application['timestamp'] as Timestamp).toDate();

            return FutureBuilder(
              future: Future.wait([
                _fetchUserData(userId),
                _fetchJobData(jobId),
              ]),
              builder: (
                context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const ListTile(title: Text('Loading...'));
                }

                final userData = snapshot.data![0];
                final jobData = snapshot.data![1];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.black),
                    title: Text(
                      '${userData['name'] ?? 'Unknown'} applied for ${jobData['title'] ?? 'Unknown Job'}',
                    ),
                    subtitle: Text(
                      '${userData['email'] ?? ''}\n${timestamp.toLocal()}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                  ),
                );
              },
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

// class WorkerApplicationsTab extends StatelessWidget {
//   const WorkerApplicationsTab({super.key});

//   Future<List<Map<String, dynamic>>> _fetchWorkerApplications() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return [];

//     final applicationsQuery =
//         await FirebaseFirestore.instance
//             .collection('applications')
//             .where('userId', isEqualTo: user.uid)
//             .orderBy('timestamp', descending: true)
//             .get();

//     List<Map<String, dynamic>> applications = [];

//     for (var doc in applicationsQuery.docs) {
//       final jobId = doc['jobId'];
//       final jobDoc =
//           await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

//       if (jobDoc.exists) {
//         applications.add({
//           'title': jobDoc['title'],
//           'company': jobDoc['company'],
//           'timestamp': doc['timestamp'],
//         });
//       }
//     }

//     return applications;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: _fetchWorkerApplications(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return const Center(child: Text('Something went wrong'));
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
//                 title: Text(app['title'] ?? 'Unknown Job'),
//                 subtitle: Text(
//                   '${app['company'] ?? 'Unknown Company'}\n${date.toLocal()}',
//                 ),
//                 isThreeLine: true,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

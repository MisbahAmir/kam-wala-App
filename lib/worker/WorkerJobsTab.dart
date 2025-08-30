// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class WorkerJobsTab extends StatelessWidget {
//   const WorkerJobsTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey[100],
//       padding: const EdgeInsets.all(8),
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No jobs available right now.'));
//           }

//           final jobs = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: jobs.length,
//             itemBuilder: (context, index) {
//               final job = jobs[index];
//               final data = job.data() as Map<String, dynamic>;

//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                 child: ListTile(
//                   title: Text(
//                     data['title'] ?? 'Untitled Job',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Company: ${data['company'] ?? 'N/A'}'),
//                       Text('Location: ${data['location'] ?? 'N/A'}'),
//                       Text('Salary: ${data['salary'] ?? 'N/A'}'),
//                       const SizedBox(height: 6),
//                       Text(
//                         data['description'] ?? '',
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                   trailing: ElevatedButton(
//                     onPressed: () {
//                       // Apply logic will go here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.yellow,
//                     ),
//                     child: const Text("Apply"),
//                   ),
//                   isThreeLine: true,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerJobsTab extends StatelessWidget {
  const WorkerJobsTab({super.key});

  Future<void> applyToJob(String jobId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    await FirebaseFirestore.instance.collection('applications').add({
      'jobId': jobId,
      'userId': user.uid,
      'userName': userData['name'] ?? 'Unknown',
      'email': user.email ?? 'No Email',
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading jobs"));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            final jobData = job.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobData['title'] ?? 'Untitled Job',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(jobData['description'] ?? 'No Description'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Posted: ${jobData['timestamp'] != null ? (jobData['timestamp'] as Timestamp).toDate().toString().split(' ')[0] : 'Unknown'}",
                        ),
                        ElevatedButton(
                          onPressed: () => applyToJob(job.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Apply"),
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
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class WorkerJobsTab extends StatelessWidget {
//   const WorkerJobsTab({super.key});

//   Future<void> applyToJob(String jobId, BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//       return;
//     }

//     final applicationRef = FirebaseFirestore.instance
//         .collection('job_applications')
//         .doc('${jobId}_${user.uid}');

//     final exists = await applicationRef.get();

//     if (exists.exists) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Already applied to this job")),
//       );
//       return;
//     }

//     await applicationRef.set({
//       'jobId': jobId,
//       'workerId': user.uid,
//       'appliedAt': FieldValue.serverTimestamp(),
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("Applied successfully")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final jobs = snapshot.data!.docs;

//         if (jobs.isEmpty) {
//           return const Center(child: Text('No jobs available.'));
//         }

//         return ListView.builder(
//           itemCount: jobs.length,
//           itemBuilder: (context, index) {
//             final job = jobs[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               color: Colors.grey[100],
//               elevation: 4,
//               child: ListTile(
//                 title: Text(
//                   job['title'],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(job['description']),
//                 trailing: ElevatedButton(
//                   onPressed: () => applyToJob(job.id, context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text("Apply"),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

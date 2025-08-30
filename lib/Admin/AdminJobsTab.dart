// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AdminJobsTab extends StatelessWidget {
//   const AdminJobsTab({super.key});

//   void _showJobDialog(BuildContext context, {DocumentSnapshot? doc}) {
//     final TextEditingController titleController = TextEditingController(
//       text: doc != null ? doc['title'] : '',
//     );
//     final TextEditingController descriptionController = TextEditingController(
//       text: doc != null ? doc['description'] : '',
//     );

//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           title: Text(doc != null ? 'Edit Job' : 'Post Job'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Job Title'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: descriptionController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () => Navigator.pop(context),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//               child: Text(doc != null ? 'Update' : 'Post'),
//               onPressed: () async {
//                 final title = titleController.text.trim();
//                 final desc = descriptionController.text.trim();

//                 if (title.isEmpty || desc.isEmpty) return;

//                 if (doc != null) {
//                   // Update
//                   await FirebaseFirestore.instance
//                       .collection('jobs')
//                       .doc(doc.id)
//                       .update({'title': title, 'description': desc});
//                 } else {
//                   // Create
//                   await FirebaseFirestore.instance.collection('jobs').add({
//                     'title': title,
//                     'description': desc,
//                     'postedAt': FieldValue.serverTimestamp(),
//                   });
//                 }

//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _deleteJob(String jobId) async {
//     await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance
//                 .collection('jobs')
//                 .orderBy('postedAt', descending: true)
//                 .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final docs = snapshot.data?.docs ?? [];

//           if (docs.isEmpty) {
//             return const Center(child: Text('No jobs posted yet.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final job = docs[index];
//               final title = job['title'] ?? 'Untitled';
//               final desc = job['description'] ?? '';

//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 margin: const EdgeInsets.only(bottom: 12),
//                 child: ListTile(
//                   title: Text(
//                     title,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(desc),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == 'edit') {
//                         _showJobDialog(context, doc: job);
//                       } else if (value == 'delete') {
//                         _deleteJob(job.id);
//                       }
//                     },
//                     itemBuilder:
//                         (context) => [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             child: Text('Edit'),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Text('Delete'),
//                           ),
//                         ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: const Icon(Icons.add, color: Colors.yellow),
//         onPressed: () => _showJobDialog(context),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminJobsTab extends StatelessWidget {
  const AdminJobsTab({super.key});

  void _showJobDialog(BuildContext context, {DocumentSnapshot? doc}) {
    final TextEditingController titleController = TextEditingController(
      text: doc != null ? doc['title'] : '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: doc != null ? doc['description'] : '',
    );
    final TextEditingController locationController = TextEditingController(
      text: doc != null ? doc['location'] ?? '' : '',
    );
    final TextEditingController salaryController = TextEditingController(
      text: doc != null ? doc['salary']?.toString() ?? '' : '',
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(doc != null ? 'Edit Job' : 'Post Job'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Job Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Salary (optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text(doc != null ? 'Update' : 'Post'),
              onPressed: () async {
                final title = titleController.text.trim();
                final desc = descriptionController.text.trim();
                final location = locationController.text.trim();
                final salary = salaryController.text.trim();

                if (title.isEmpty || desc.isEmpty) return;

                final jobData = {
                  'title': title,
                  'description': desc,
                  'location': location,
                  'salary': salary.isNotEmpty ? double.tryParse(salary) : null,
                  'postedAt': FieldValue.serverTimestamp(),
                };

                if (doc != null) {
                  await FirebaseFirestore.instance
                      .collection('jobs')
                      .doc(doc.id)
                      .update(jobData);
                } else {
                  await FirebaseFirestore.instance
                      .collection('jobs')
                      .add(jobData);
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteJob(String jobId) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('jobs')
                .orderBy('postedAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No jobs posted yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final job = docs[index];
              final title = job['title'] ?? 'Untitled';
              final desc = job['description'] ?? '';
              final location = job['location'] ?? 'Unknown';
              final salary =
                  job['salary'] != null ? 'Rs. ${job['salary']}' : 'N/A';
              final postedAt = _formatTimestamp(job['postedAt']);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(desc),
                        const SizedBox(height: 6),
                        Text('📍 Location: $location'),
                        Text('💰 Salary: $salary'),
                        Text('🕒 Posted: $postedAt'),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showJobDialog(context, doc: job);
                      } else if (value == 'delete') {
                        _deleteJob(job.id);
                      }
                    },
                    itemBuilder:
                        (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showJobDialog(context),
        tooltip: 'Post New Job',
        child: const Icon(Icons.add, color: Colors.yellow),
      ),
    );
  }
}

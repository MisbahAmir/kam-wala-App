import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserJobsTab extends StatefulWidget {
  const UserJobsTab({super.key});

  @override
  State<UserJobsTab> createState() => _UserJobsTabState();
}

class _UserJobsTabState extends State<UserJobsTab> {
  List<DocumentSnapshot> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('jobs')
              .orderBy('timestamp', descending: true)
              .get();

      setState(() {
        _jobs = querySnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching jobs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildJobItem(DocumentSnapshot doc) {
    final job = doc.data() as Map<String, dynamic>;

    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          job['title'] ?? 'No Title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.yellowAccent,
          ),
        ),
        subtitle: Text(
          job['company'] ?? '',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              job['location'] ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              job['salary']?.toString() ?? '',
              style: const TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
        onTap: () {
          // Navigate to job details screen (if needed)
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _jobs.isEmpty
        ? const Center(
          child: Text(
            'No jobs available.',
            style: TextStyle(color: Colors.white),
          ),
        )
        : ListView.builder(
          itemCount: _jobs.length,
          itemBuilder: (context, index) {
            return buildJobItem(_jobs[index]);
          },
        );
  }
}

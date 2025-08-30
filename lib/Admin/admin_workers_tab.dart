import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminWorkersTab extends StatelessWidget {
  const AdminWorkersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'worker')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No workers found'));
        }

        final workers = snapshot.data!.docs;

        return ListView.builder(
          itemCount: workers.length,
          itemBuilder: (context, index) {
            final user = workers[index];
            final data = user.data() as Map<String, dynamic>?;

            final name = data?['name'] ?? 'Unknown';
            final email = data?['email'] ?? 'No email';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(title: Text(name), subtitle: Text(email)),
            );
          },
        );
      },
    );
  }
}

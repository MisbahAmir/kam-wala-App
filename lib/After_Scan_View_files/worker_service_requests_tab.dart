import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkerServiceRequestsTab extends StatelessWidget {
  const WorkerServiceRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Service Requests - Worker',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('service_requests')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No service requests yet",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;

              final userName = data['userName'] ?? 'N/A';
              final userEmail = data['userEmail'] ?? 'N/A';
              final userPhone = data['userPhone'] ?? 'N/A';
              final service = data['service'] ?? 'N/A';
              final subtitle = data['subtitle'] ?? '';
              final status = data['status'] ?? 'pending';
              final timestamp =
                  data['timestamp'] != null
                      ? DateFormat.yMd().add_jm().format(
                        (data['timestamp'] as Timestamp).toDate(),
                      )
                      : 'N/A';

              return Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    '$service',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        "User: $userName",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Email: $userEmail",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Phone: $userPhone",
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          "Note: $subtitle",
                          style: const TextStyle(color: Colors.white),
                        ),
                      Text(
                        "Status: $status",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Requested: $timestamp",
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

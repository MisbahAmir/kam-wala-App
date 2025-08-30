import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkerElectricianRequestsTab extends StatelessWidget {
  const WorkerElectricianRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrician Requests (Worker)'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('electrician_requests')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests available.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedDate =
                  timestamp != null
                      ? DateFormat(
                        'yyyy-MM-dd – kk:mm',
                      ).format(timestamp.toDate())
                      : 'N/A';

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    '${data['name'] ?? 'N/A'} - ${data['service'] ?? 'N/A'}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${data['email'] ?? 'N/A'}'),
                      Text('Phone: ${data['phone'] ?? 'N/A'}'),
                      Text('Address: ${data['address'] ?? 'N/A'}'),
                      Text('Requested on: $formattedDate'),
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

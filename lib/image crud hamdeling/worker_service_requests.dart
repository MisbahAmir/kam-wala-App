import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerServiceRequests1 extends StatefulWidget {
  final String workerId; // workerId pass karo jab is page ko open karo

  const WorkerServiceRequests1({super.key, required this.workerId});

  @override
  State<WorkerServiceRequests1> createState() => _WorkerServiceRequests1State();
}

class _WorkerServiceRequests1State extends State<WorkerServiceRequests1> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> etaOptions = ["15 mins", "30 mins", "1 hr"];

  void _acceptRequest(String requestId, String eta) async {
    await _firestore.collection("serviceRequests").doc(requestId).update({
      "status": "accepted",
      "acceptedBy": widget.workerId,
      "eta": eta,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Job accepted with ETA: $eta")));
  }

  void _rejectRequest(String requestId) async {
    await _firestore.collection("serviceRequests").doc(requestId).update({
      "status": "rejected",
      "acceptedBy": null,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Job rejected")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Requests"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection("serviceRequests")
                .where("status", isEqualTo: "pending")
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(child: Text("No service request right now"));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];
              var data = request.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service: ${data['serviceName']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("Charges: Rs. ${data['charges']}"),
                      Text("Customer: ${data['customerName']}"),
                      Text("Location: ${data['location']}"),

                      const SizedBox(height: 10),

                      // ETA selection chips
                      Wrap(
                        spacing: 8,
                        children:
                            etaOptions.map((eta) {
                              return ActionChip(
                                label: Text(eta),
                                onPressed:
                                    () => _acceptRequest(request.id, eta),
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 10),

                      // Reject button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () => _rejectRequest(request.id),
                          child: const Text("Reject"),
                        ),
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

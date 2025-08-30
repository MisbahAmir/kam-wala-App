import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerJobRequestScreen extends StatefulWidget {
  final String workerId;
  const WorkerJobRequestScreen({super.key, required this.workerId});

  @override
  State<WorkerJobRequestScreen> createState() => _WorkerJobRequestScreenState();
}

class _WorkerJobRequestScreenState extends State<WorkerJobRequestScreen>
    with SingleTickerProviderStateMixin {
  String? selectedETA;

  void _acceptJob(String orderId) async {
    if (selectedETA == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select ETA first")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "accepted",
      "acceptedBy": widget.workerId,
      "ETA": selectedETA,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("✅ Job Accepted")));
  }

  void _rejectJob(String orderId) async {
    await FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "rejected",
      "rejectedBy": widget.workerId,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("❌ Job Rejected")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Job Requests",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection("orders")
                  .where("status", isEqualTo: "assigned")
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No job requests yet 🚫",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              );
            }

            final requests = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 90, 16, 80),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                final data = req.data() as Map<String, dynamic>? ?? {};

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.9), Colors.blue[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with icon + title + status
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(
                                Icons.build,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                data['serviceName'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Chip(
                              label: const Text(
                                "Assigned",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: Colors.blue.shade600,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Text(
                          "💰 Charges: Rs. ${data['charges'] ?? 0}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const Divider(height: 25, thickness: 1),

                        // ETA selection
                        const Text(
                          "⏳ Select ETA:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children:
                              ["15 min", "30 min", "1 hr"].map((eta) {
                                return ChoiceChip(
                                  label: Text(
                                    eta,
                                    style: TextStyle(
                                      color:
                                          selectedETA == eta
                                              ? Colors.white
                                              : Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  selected: selectedETA == eta,
                                  selectedColor: Colors.blue.shade600,
                                  backgroundColor: Colors.blue.shade50,
                                  elevation: 3,
                                  pressElevation: 5,
                                  onSelected:
                                      (_) => setState(() => selectedETA = eta),
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 18),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _acceptJob(req.id),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text("Accept"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _rejectJob(req.id),
                              icon: const Icon(Icons.cancel_outlined),
                              label: const Text("Reject"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                              ),
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
        ),
      ),

      // Floating Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton(
          //   heroTag: "filter",
          //   backgroundColor: Colors.blue.shade600,
          //   onPressed: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text("🔍 Filter options coming soon")),
          //     );
          //   },
          //   child: const Icon(Icons.filter_list, color: Colors.white),
          // ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "refresh",
            backgroundColor: Colors.green.shade600,
            onPressed: () {
              setState(() {}); // refresh data
            },
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

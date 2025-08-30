import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerDashboard extends StatefulWidget {
  final String workerId;
  const WorkerDashboard({super.key, required this.workerId});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPendingJobs(),
            const SizedBox(height: 20),
            _buildOngoingJobs(),
            const SizedBox(height: 20),
            _buildCompletedJobs(),
          ],
        ),
      ),
    );
  }

  /// ---------------- PENDING JOBS ----------------
  Widget _buildPendingJobs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("serviceRequests")
          .where("status", isEqualTo: "pending")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text("No pending jobs right now");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pending Jobs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...snapshot.data!.docs.map((doc) {
              var job = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.pending_actions),
                  title: Text(job["serviceName"] ?? "Unknown Service"),
                  subtitle: Text("Customer: ${job["customerName"] ?? ''}"),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("serviceRequests")
                          .doc(doc.id)
                          .update({
                        "status": "ongoing",
                        "acceptedBy": widget.workerId,
                      });
                    },
                    child: const Text("Accept"),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  /// ---------------- ONGOING JOBS ----------------
  Widget _buildOngoingJobs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("serviceRequests")
          .where("acceptedBy", isEqualTo: widget.workerId)
          .where("status", isEqualTo: "ongoing")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text("No ongoing jobs right now");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ongoing Jobs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...snapshot.data!.docs.map((doc) {
              var job = doc.data() as Map<String, dynamic>;
              return Card(
                color: Colors.yellow[100],
                child: ListTile(
                  leading: const Icon(Icons.work_history),
                  title: Text(job["serviceName"] ?? "Unknown Service"),
                  subtitle: Text("Customer: ${job["customerName"] ?? ''}"),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("serviceRequests")
                          .doc(doc.id)
                          .update({"status": "done"});
                    },
                    child: const Text("Mark Done"),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  /// ---------------- COMPLETED JOBS ----------------
  Widget _buildCompletedJobs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("serviceRequests")
          .where("acceptedBy", isEqualTo: widget.workerId)
          .where("status", isEqualTo: "done")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text("No completed jobs yet");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Completed Jobs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...snapshot.data!.docs.map((doc) {
              var job = doc.data() as Map<String, dynamic>;
              return Card(
                color: Colors.green[100],
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(job["serviceName"] ?? "Unknown Service"),
                  subtitle: Text("Customer: ${job["customerName"] ?? ''}"),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

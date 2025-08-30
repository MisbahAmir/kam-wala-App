import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f7fe),
      appBar: AppBar(
        title: const Text("Order Details"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff2193b0), Color(0xff6dd5ed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text("Order not found"));
          }

          final status      = (data["status"] ?? "pending").toString();
          final service     = (data["serviceName"] ?? "").toString();
          final charges     = data["charges"]?.toString() ?? "0";
          final workerName  = (data["workerName"] ?? "—").toString();
          final eta         = (data["ETA"] ?? "—").toString();

          return Padding(
            padding: const EdgeInsets.all(18),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Order Summary",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Status: ", style: TextStyle(fontSize: 16)),
                        Chip(
                          label: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white)),
                          backgroundColor: _statusColor(status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _row("Service", service),
                    _row("Charges", "Rs $charges"),
                    _row("Worker", workerName),
                    _row("ETA", eta),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _row(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text("$key:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "assigned":
        return Colors.blue;
      case "in-progress":
        return Colors.purple;
      case "completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

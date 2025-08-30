import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ========================= ADMIN SCREEN =========================
class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  State<AdminAppointmentsScreen> createState() =>
      _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Accept / Reject
  Future<void> _updateStatus(String id, String status) async {
    await _firestore.collection("appointments").doc(id).update({
      "status": status,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: status == "accepted" ? Colors.green : Colors.red,
          content: Text("Request $status"),
        ),
      );
    }
  }

  /// Delete with confirmation
  Future<void> _deleteAppointment(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this appointment?",
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _firestore.collection("appointments").doc(id).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Appointment deleted"),
          ),
        );
      }
    }
  }

  /// Row Widget for details
  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.pink, size: 20),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Appointments"),
        backgroundColor: const Color.fromARGB(255, 255, 131, 172),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection("appointments")
                .orderBy("createdAt", descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Appointments Found"));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final m = data[index].data() as Map<String, dynamic>;
              final id = data[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Service Name
                      Text(
                        m["serviceName"] ?? "No Service",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(height: 8),

                      _detailRow(
                        Icons.category,
                        "Category",
                        m["category"] ?? "N/A",
                      ),
                      _detailRow(
                        Icons.price_change,
                        "Price",
                        "Rs. ${m["price"] ?? "N/A"}",
                      ),
                      _detailRow(Icons.date_range, "Date", m["date"] ?? "N/A"),
                      _detailRow(Icons.access_time, "Time", m["time"] ?? "N/A"),
                      _detailRow(
                        Icons.location_on,
                        "Location",
                        m["location"] ?? "N/A",
                      ),
                      _detailRow(Icons.info, "Status", m["status"] ?? "N/A"),

                      const SizedBox(height: 10),

                      /// Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => _updateStatus(id, "accepted"),
                            icon: const Icon(Icons.check, color: Colors.green),
                            label: const Text("Accept"),
                          ),
                          TextButton.icon(
                            onPressed: () => _updateStatus(id, "rejected"),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text("Reject"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAppointment(id),
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
    );
  }
}

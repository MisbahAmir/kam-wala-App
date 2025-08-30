// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AdminServiceDetailScreen extends StatefulWidget {
//   const AdminServiceDetailScreen({super.key});

//   @override
//   State<AdminServiceDetailScreen> createState() =>
//       _AdminServiceDetailScreenState();
// }

// class _AdminServiceDetailScreenState extends State<AdminServiceDetailScreen> {
//   String searchQuery = "";

//   // Update order status in Firestore
//   void _updateStatus(String docId, String newStatus) async {
//     await FirebaseFirestore.instance.collection("orders").doc(docId).update({
//       "status": newStatus,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffe3f2fd),
//       appBar: AppBar(
//         title: const Text("All Service Records"),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xff00c6ff), Color(0xff0072ff)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) => setState(() => searchQuery = value),
//               decoration: InputDecoration(
//                 hintText: "Search by worker or service...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 0,
//                   horizontal: 16,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance
//                 .collection("orders")
//                 .orderBy("timestamp", descending: true)
//                 .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No service records yet",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           final orders =
//               snapshot.data!.docs.where((doc) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final workerName =
//                     data["workerName"]?.toString().toLowerCase() ?? "";
//                 final serviceName =
//                     data["serviceName"]?.toString().toLowerCase() ?? "";
//                 final query = searchQuery.toLowerCase();
//                 return workerName.contains(query) ||
//                     serviceName.contains(query);
//               }).toList();

//           if (orders.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No matching records found",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final data = orders[index].data() as Map<String, dynamic>;
//               final status = data["status"] ?? "pending";
//               final docId = orders[index].id;

//               Color statusColor =
//                   status == "completed" ? Colors.green : Colors.orange;
//               IconData statusIcon =
//                   status == "completed" ? Icons.check_circle : Icons.pending;

//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 6,
//                 shadowColor: Colors.blue.shade100,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.blue.shade100,
//                           child: Text(
//                             data["workerName"]?[0] ?? "?",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           data["serviceName"] ?? "Unknown Service",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 6),
//                             Text("Worker: ${data["workerName"] ?? "-"}"),
//                             if (data["workerPhone"] != null)
//                               Text("Phone: ${data["workerPhone"]}"),
//                             Text("Charges: Rs. ${data["charges"] ?? "-"}"),
//                             const SizedBox(height: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 4,
//                                 horizontal: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: statusColor.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     statusIcon,
//                                     color: statusColor,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     status.toUpperCase(),
//                                     style: TextStyle(
//                                       color: statusColor,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing:
//                             status == "pending"
//                                 ? ElevatedButton(
//                                   onPressed:
//                                       () => _updateStatus(docId, "completed"),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "Mark Done",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 )
//                                 : null,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerRecordDetailScreen extends StatefulWidget {
  final String workerId; // Worker UID
  const WorkerRecordDetailScreen({super.key, required this.workerId});

  @override
  State<WorkerRecordDetailScreen> createState() =>
      _WorkerRecordDetailScreenState();
}

class _WorkerRecordDetailScreenState extends State<WorkerRecordDetailScreen> {
  String searchQuery = "";
  String sortOption = "latest"; // latest, oldest, charges

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f7fe),
      appBar: AppBar(
        title: const Text("My Service Requests"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff2193b0), Color(0xff6dd5ed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by service name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Sort dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                const Text("Sort by: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: sortOption,
                  items: const [
                    DropdownMenuItem(
                        value: "latest", child: Text("Latest")),
                    DropdownMenuItem(
                        value: "oldest", child: Text("Oldest")),
                    DropdownMenuItem(
                        value: "charges", child: Text("Charges")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        sortOption = value;
                      });
                    }
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Records list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .where("workerId", isEqualTo: widget.workerId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No service requests yet"));
                }

                // Filter and sort
                List<QueryDocumentSnapshot> orders = snapshot.data!.docs
                    .where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final serviceName =
                          (data["serviceName"] ?? "").toString().toLowerCase();
                      return serviceName.contains(searchQuery);
                    })
                    .toList();

                orders.sort((a, b) {
                  final dataA = a.data() as Map<String, dynamic>;
                  final dataB = b.data() as Map<String, dynamic>;

                  Timestamp tsA = dataA["timestamp"] ??
                      Timestamp.fromMillisecondsSinceEpoch(0);
                  Timestamp tsB = dataB["timestamp"] ??
                      Timestamp.fromMillisecondsSinceEpoch(0);

                  switch (sortOption) {
                    case "oldest":
                      return tsA.compareTo(tsB);
                    case "charges":
                      return (dataB["charges"] ?? 0)
                          .compareTo(dataA["charges"] ?? 0);
                    default: // latest
                      return tsB.compareTo(tsA);
                  }
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final data = orders[index].data() as Map<String, dynamic>;
                    final status = data["status"] ?? "pending";

                    // ETA progress calculation
                    double etaProgress = 0;
                    if (data["ETA"] != null) {
                      final etaMin = int.tryParse(
                              data["ETA"].toString().replaceAll(" min", "")) ??
                          0;
                      etaProgress = (etaMin / 60).clamp(0.0, 1.0);
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            data["workerName"]?[0] ?? "?",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        title: Text(
                          data["serviceName"] ?? "Unknown Service",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text("Charges: Rs. ${data["charges"] ?? "-"}"),
                            const SizedBox(height: 4),
                            Text(
                              "Status: ${status.toUpperCase()}",
                              style: TextStyle(
                                color: status == "completed"
                                    ? Colors.green
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: etaProgress,
                              backgroundColor: Colors.grey.shade200,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                        trailing: Icon(
                          status == "completed"
                              ? Icons.check_circle
                              : Icons.pending_actions,
                          color: status == "completed"
                              ? Colors.green
                              : Colors.redAccent,
                          size: 28,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


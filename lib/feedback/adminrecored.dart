import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kam_wala_app/feedback/Bubble%20Feedback%20Widget.dart';

class AdminFeedbackDashboard extends StatefulWidget {
  const AdminFeedbackDashboard({super.key});

  @override
  State<AdminFeedbackDashboard> createState() => _AdminFeedbackDashboardState();
}

class _AdminFeedbackDashboardState extends State<AdminFeedbackDashboard> {
  final userRef = FirebaseDatabase.instance.ref('feedback/users');
  final workerRef = FirebaseDatabase.instance.ref('feedback/workers');

  String filterType = 'all';

  void replyFeedback(DatabaseReference ref, String key, String replyText) {
    ref.child(key).update({'reply': replyText});
  }

  void deleteFeedback(DatabaseReference ref, String key) {
    ref.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Feedback Dashboard"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [
            // Filter buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: Text("All"),
                    selected: filterType == 'all',
                    onSelected: (_) => setState(() => filterType = 'all'),
                  ),
                  SizedBox(width: 10),
                  FilterChip(
                    label: Text("User"),
                    selected: filterType == 'user',
                    onSelected: (_) => setState(() => filterType = 'user'),
                  ),
                  SizedBox(width: 10),
                  FilterChip(
                    label: Text("Worker"),
                    selected: filterType == 'worker',
                    onSelected: (_) => setState(() => filterType = 'worker'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder(
                stream: userRef.onValue,
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final userData = userSnapshot.data!.snapshot.value;
                  List<Map<String, dynamic>> feedbackList = [];

                  if ((filterType == 'all' || filterType == 'user') &&
                      userData != null &&
                      userData is Map<dynamic, dynamic>) {
                    userData.forEach((key, value) {
                      feedbackList.add({
                        'key': key,
                        'message': value['message'],
                        'reply': value['reply'],
                        'ref': userRef,
                        'type': 'user',
                        'timestamp': value['timestamp'] ?? 0,
                      });
                    });
                  }

                  return StreamBuilder(
                    stream: workerRef.onValue,
                    builder: (context, workerSnapshot) {
                      if (!workerSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final workerData = workerSnapshot.data!.snapshot.value;

                      if ((filterType == 'all' || filterType == 'worker') &&
                          workerData != null &&
                          workerData is Map<dynamic, dynamic>) {
                        workerData.forEach((key, value) {
                          feedbackList.add({
                            'key': key,
                            'message': value['message'],
                            'reply': value['reply'],
                            'ref': workerRef,
                            'type': 'worker',
                            'timestamp': value['timestamp'] ?? 0,
                          });
                        });
                      }

                      // Sort by timestamp
                      feedbackList.sort(
                        (a, b) => (a['timestamp'] as int).compareTo(
                          b['timestamp'] as int,
                        ),
                      );

                      return ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: feedbackList.length,
                        itemBuilder: (context, index) {
                          final item = feedbackList[index];
                          TextEditingController replyController =
                              TextEditingController(text: item['reply']);
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item['type'].toUpperCase()} Feedback:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                        255,
                                        245,
                                        136,
                                        63,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(item['message']),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: replyController,
                                    decoration: InputDecoration(
                                      hintText: "Reply here...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed:
                                            () => replyFeedback(
                                              item['ref'],
                                              item['key'],
                                              replyController.text,
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            219,
                                            234,
                                            83,
                                          ),
                                        ),
                                        child: Text("Reply"),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed:
                                            () => deleteFeedback(
                                              item['ref'],
                                              item['key'],
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            250,
                                            164,
                                            88,
                                          ),
                                        ),
                                        child: Text("Delete"),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:kam_wala_app/feedback/Bubble%20Feedback%20Widget.dart';

// class AdminFeedbackDashboard extends StatefulWidget {
//   const AdminFeedbackDashboard({super.key});

//   @override
//   State<AdminFeedbackDashboard> createState() => _AdminFeedbackDashboardState();
// }

// class _AdminFeedbackDashboardState extends State<AdminFeedbackDashboard>
//     with SingleTickerProviderStateMixin {
//   final userRef = FirebaseDatabase.instance.ref('feedback/users');
//   final workerRef = FirebaseDatabase.instance.ref('feedback/workers');

//   String filterType = 'all';

//   late AnimationController _animationController;
//   late Animation<Color?> _backgroundColor;

//   @override
//   void initState() {
//     super.initState();
//     // Background animation setup
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 6),
//     )..repeat(reverse: true);

//     _backgroundColor = ColorTween(
//       begin: Colors.blue.shade50,
//       end: Colors.blue.shade200,
//     ).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void replyFeedback(DatabaseReference ref, String key, String replyText) {
//     ref.child(key).update({'reply': replyText});
//   }

//   void deleteFeedback(DatabaseReference ref, String key) {
//     ref.child(key).remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _backgroundColor,
//       builder: (context, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "Admin Feedback Dashboard",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.blue.shade700,
//             elevation: 0,
//           ),
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.white, _backgroundColor.value!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               children: [
//                 // Filter Chips
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: Wrap(
//                     spacing: 10,
//                     children: [
//                       ChoiceChip(
//                         label: Text("All"),
//                         selected: filterType == 'all',
//                         onSelected: (_) => setState(() => filterType = 'all'),
//                         selectedColor: Colors.blue.shade700,
//                         backgroundColor: Colors.blue.shade100,
//                         labelStyle: TextStyle(
//                           color:
//                               filterType == 'all' ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ChoiceChip(
//                         label: Text("User"),
//                         selected: filterType == 'user',
//                         onSelected: (_) => setState(() => filterType = 'user'),
//                         selectedColor: Colors.blue.shade700,
//                         backgroundColor: Colors.blue.shade100,
//                         labelStyle: TextStyle(
//                           color:
//                               filterType == 'user'
//                                   ? Colors.white
//                                   : Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ChoiceChip(
//                         label: Text("Worker"),
//                         selected: filterType == 'worker',
//                         onSelected:
//                             (_) => setState(() => filterType = 'worker'),
//                         selectedColor: Colors.blue.shade700,
//                         backgroundColor: Colors.blue.shade100,
//                         labelStyle: TextStyle(
//                           color:
//                               filterType == 'worker'
//                                   ? Colors.white
//                                   : Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Feedback List
//                 Expanded(
//                   child: StreamBuilder(
//                     stream: userRef.onValue,
//                     builder: (context, userSnapshot) {
//                       if (!userSnapshot.hasData) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.blue.shade700,
//                           ),
//                         );
//                       }

//                       final userData = userSnapshot.data!.snapshot.value;
//                       List<Map<String, dynamic>> feedbackList = [];

//                       if ((filterType == 'all' || filterType == 'user') &&
//                           userData != null &&
//                           userData is Map<dynamic, dynamic>) {
//                         userData.forEach((key, value) {
//                           feedbackList.add({
//                             'key': key,
//                             'message': value['message'],
//                             'reply': value['reply'],
//                             'ref': userRef,
//                             'type': 'user',
//                             'timestamp': value['timestamp'] ?? 0,
//                           });
//                         });
//                       }

//                       return StreamBuilder(
//                         stream: workerRef.onValue,
//                         builder: (context, workerSnapshot) {
//                           if (!workerSnapshot.hasData) {
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.blue.shade700,
//                               ),
//                             );
//                           }

//                           final workerData =
//                               workerSnapshot.data!.snapshot.value;

//                           if ((filterType == 'all' || filterType == 'worker') &&
//                               workerData != null &&
//                               workerData is Map<dynamic, dynamic>) {
//                             workerData.forEach((key, value) {
//                               feedbackList.add({
//                                 'key': key,
//                                 'message': value['message'],
//                                 'reply': value['reply'],
//                                 'ref': workerRef,
//                                 'type': 'worker',
//                                 'timestamp': value['timestamp'] ?? 0,
//                               });
//                             });
//                           }

//                           feedbackList.sort(
//                             (a, b) => (a['timestamp'] as int).compareTo(
//                               b['timestamp'] as int,
//                             ),
//                           );

//                           return ListView.builder(
//                             padding: const EdgeInsets.all(12),
//                             itemCount: feedbackList.length,
//                             itemBuilder: (context, index) {
//                               final item = feedbackList[index];
//                               TextEditingController replyController =
//                                   TextEditingController(text: item['reply']);

//                               return AnimatedPadding(
//                                 duration: Duration(milliseconds: 400),
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 6.0,
//                                 ),
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   elevation: 5,
//                                   shadowColor: Colors.blue.shade200,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "${item['type'].toUpperCase()} Feedback:",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                             color: Colors.blue.shade700,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           item['message'],
//                                           style: TextStyle(fontSize: 14),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         TextField(
//                                           controller: replyController,
//                                           decoration: InputDecoration(
//                                             hintText: "Reply here...",
//                                             filled: true,
//                                             fillColor: Colors.grey.shade100,
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                               borderSide: BorderSide.none,
//                                             ),
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                   horizontal: 14,
//                                                   vertical: 12,
//                                                 ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             ElevatedButton.icon(
//                                               onPressed:
//                                                   () => replyFeedback(
//                                                     item['ref'],
//                                                     item['key'],
//                                                     replyController.text,
//                                                   ),
//                                               icon: Icon(Icons.reply),
//                                               label: Text("Reply"),
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     const Color.fromARGB(
//                                                       255,
//                                                       107,
//                                                       227,
//                                                       107,
//                                                     ),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                 ),
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                       horizontal: 14,
//                                                       vertical: 10,
//                                                     ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10),
//                                             ElevatedButton.icon(
//                                               onPressed:
//                                                   () => deleteFeedback(
//                                                     item['ref'],
//                                                     item['key'],
//                                                   ),
//                                               icon: Icon(Icons.delete),
//                                               label: Text("Delete"),
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     const Color.fromARGB(
//                                                       255,
//                                                       215,
//                                                       126,
//                                                       243,
//                                                     ),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                 ),
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                       horizontal: 14,
//                                                       vertical: 10,
//                                                     ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:kam_wala_app/feedback/Bubble%20Feedback%20Widget.dart';

// class WorkerFeedbackScreen extends StatefulWidget {
//   final String workerId;
//   const WorkerFeedbackScreen({super.key, required this.workerId});

//   @override
//   State<WorkerFeedbackScreen> createState() => _WorkerFeedbackScreenState();
// }

// class _WorkerFeedbackScreenState extends State<WorkerFeedbackScreen> {
//   final databaseRef = FirebaseDatabase.instance.ref('feedback/workers');
//   final TextEditingController messageController = TextEditingController();

//   void sendFeedback() {
//     if (messageController.text.trim().isEmpty) return;

//     databaseRef.push().set({
//       'message': messageController.text.trim(),
//       'reply': '',
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'workerId': widget.workerId,
//     });

//     messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Worker Feedback"),
//         backgroundColor: Colors.blue.shade700,
//       ),
//       body: Container(
//         color: Colors.blue.shade50,
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder(
//                 stream: databaseRef.onValue,
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   final event = snapshot.data!.snapshot;
//                   final rawData = event.value;

//                   List feedbackList = [];
//                   if (rawData != null && rawData is Map<dynamic, dynamic>) {
//                     rawData.forEach((key, value) {
//                       feedbackList.add(value);
//                     });
//                   }

//                   feedbackList.sort(
//                     (a, b) => (a['timestamp'] as int).compareTo(
//                       b['timestamp'] as int,
//                     ),
//                   );

//                   return ListView.builder(
//                     padding: EdgeInsets.all(10),
//                     itemCount: feedbackList.length,
//                     itemBuilder: (context, index) {
//                       final item = feedbackList[index];
//                       return FeedbackBubble(
//                         message: item['message'] ?? "",
//                         sender: 'user', // bubble style same as user
//                         reply: item['reply'] ?? "",
//                         shadow: true,
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),

//             // Input + send button
//             Container(
//               color: Colors.blue.shade100,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: messageController,
//                       decoration: InputDecoration(
//                         hintText: "Type feedback...",
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: sendFeedback,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade700,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 18,
//                         vertical: 15,
//                       ),
//                     ),
//                     child: Icon(Icons.send, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kam_wala_app/feedback/Bubble%20Feedback%20Widget.dart';
import 'package:translator/translator.dart'; // ⬅️ real translation

class WorkerFeedbackScreen extends StatefulWidget {
  final String workerId;
  const WorkerFeedbackScreen({super.key, required this.workerId});

  @override
  State<WorkerFeedbackScreen> createState() => _WorkerFeedbackScreenState();
}

class _WorkerFeedbackScreenState extends State<WorkerFeedbackScreen> {
  final databaseRef = FirebaseDatabase.instance.ref('feedback/workers');
  final TextEditingController messageController = TextEditingController();

  // ⬇️ translator + per-item caches (keyed by timestamp+message)
  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _urduCache = {}; // key -> urdu text
  final Map<String, bool> _showUrdu = {}; // key -> show/hide
  final Set<String> _loadingKeys = {}; // keys currently loading

  void sendFeedback() {
    if (messageController.text.trim().isEmpty) return;

    databaseRef.push().set({
      'message': messageController.text.trim(),
      'reply': '',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'workerId': widget.workerId,
    });

    messageController.clear();
  }

  String _makeKey(Map item) {
    final ts = (item['timestamp'] ?? '').toString();
    final msg = (item['message'] ?? '').toString();
    return '${ts}_$msg';
  }

  Future<void> _toggleTranslation(Map item) async {
    final key = _makeKey(item);
    // If already showing, just hide
    if ((_showUrdu[key] ?? false) == true) {
      setState(() => _showUrdu[key] = false);
      return;
    }
    // If cached, just show
    if (_urduCache.containsKey(key)) {
      setState(() => _showUrdu[key] = true);
      return;
    }
    // Else fetch translation once
    final text = (item['message'] ?? '').toString().trim();
    if (text.isEmpty) return;

    setState(() => _loadingKeys.add(key));
    try {
      final res = await _translator.translate(text, to: 'ur');
      setState(() {
        _urduCache[key] = res.text;
        _showUrdu[key] = true;
      });
    } catch (e) {
      // Optional: show a toast/snackbar on failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Translation failed. Please try again.')),
      );
    } finally {
      setState(() => _loadingKeys.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Feedback"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: databaseRef.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final event = snapshot.data!.snapshot;
                  final rawData = event.value;

                  List feedbackList = [];
                  if (rawData != null && rawData is Map<dynamic, dynamic>) {
                    rawData.forEach((key, value) {
                      feedbackList.add(value);
                    });
                  }

                  feedbackList.sort(
                    (a, b) => (a['timestamp'] as int).compareTo(
                      b['timestamp'] as int,
                    ),
                  );

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final item = feedbackList[index];
                      final key = _makeKey(item);
                      final message = (item['message'] ?? "").toString();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FeedbackBubble(
                            message: message,
                            sender: 'user', // bubble style same as user
                            reply: item['reply'] ?? "",
                            shadow: true,
                          ),

                          // Toggle button (styling minimal, consistent with screen)
                          TextButton(
                            onPressed: () => _toggleTranslation(item),
                            child:
                                _loadingKeys.contains(key)
                                    ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      (_showUrdu[key] ?? false)
                                          ? "Hide Translation"
                                          : "Show Translation",
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                          ),

                          // Urdu translation (shown only when toggled ON)
                          if ((_showUrdu[key] ?? false) &&
                              (_urduCache[key]?.isNotEmpty ?? false))
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                bottom: 8,
                                right: 12,
                              ),
                              child: Text(
                                _urduCache[key]!,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 14,
                                  // light styling only; no color/layout changes
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Input + send button (unchanged)
            Container(
              color: Colors.blue.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type feedback...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: sendFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

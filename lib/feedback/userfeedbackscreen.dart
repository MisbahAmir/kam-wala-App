// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:kam_wala_app/feedback/Bubble%20Feedback%20Widget.dart';

// class UserFeedbackScreen extends StatefulWidget {
//   final String userId;
//   const UserFeedbackScreen({super.key, required this.userId});

//   @override
//   State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
// }

// class _UserFeedbackScreenState extends State<UserFeedbackScreen>
//     with SingleTickerProviderStateMixin {
//   final databaseRef = FirebaseDatabase.instance.ref('feedback/users');
//   final TextEditingController messageController = TextEditingController();

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
//     messageController.dispose();
//     super.dispose();
//   }

//   void sendFeedback() {
//     if (messageController.text.trim().isEmpty) return;

//     databaseRef.push().set({
//       'message': messageController.text.trim(),
//       'reply': '',
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'userId': widget.userId,
//     });

//     messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _backgroundColor,
//       builder: (context, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "User Feedback",
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
//                 // Feedback List
//                 Expanded(
//                   child: StreamBuilder(
//                     stream: databaseRef.onValue,
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.blue.shade700,
//                           ),
//                         );
//                       }

//                       final event = snapshot.data!.snapshot;
//                       final rawData = event.value;
//                       List feedbackList = [];

//                       if (rawData != null && rawData is Map<dynamic, dynamic>) {
//                         rawData.forEach((key, value) {
//                           feedbackList.add(value);
//                         });
//                       }

//                       feedbackList.sort(
//                         (a, b) => (a['timestamp'] as int).compareTo(
//                           b['timestamp'] as int,
//                         ),
//                       );

//                       return ListView.builder(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         itemCount: feedbackList.length,
//                         itemBuilder: (context, index) {
//                           final item = feedbackList[index];
//                           return AnimatedPadding(
//                             duration: Duration(milliseconds: 500),
//                             padding: const EdgeInsets.symmetric(vertical: 4.0),
//                             child: FeedbackBubble(
//                               message: item['message'] ?? "",
//                               sender: 'user',
//                               reply: item['reply'] ?? "",
//                               shadow: true,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),

//                 // Input Field + Send Button
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue.shade100, Colors.blue.shade300],
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: messageController,
//                           decoration: InputDecoration(
//                             hintText: "Type feedback...",
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: sendFeedback,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade700,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                         ),
//                         child: const Icon(Icons.send, color: Colors.white),
//                       ),
//                     ],
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



import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kam_wala_app/feedback/Bubble%20Feedback%20Widget.dart';
import 'package:translator/translator.dart';

class UserFeedbackScreen extends StatefulWidget {
  final String userId;
  const UserFeedbackScreen({super.key, required this.userId});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen>
    with SingleTickerProviderStateMixin {
  final databaseRef = FirebaseDatabase.instance.ref('feedback/users');
  final TextEditingController messageController = TextEditingController();
  final translator = GoogleTranslator();

  late AnimationController _animationController;
  late Animation<Color?> _backgroundColor;

  // Map to hold translations for each message
  final Map<int, String> _translations = {};
  final Map<int, bool> _showTranslation = {};

  @override
  void initState() {
    super.initState();

    // Background animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _backgroundColor = ColorTween(
      begin: Colors.blue.shade50,
      end: Colors.blue.shade200,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void sendFeedback() {
    if (messageController.text.trim().isEmpty) return;

    databaseRef.push().set({
      'message': messageController.text.trim(),
      'reply': '',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': widget.userId,
    });

    messageController.clear();
  }

  Future<void> _translateMessage(int index, String text) async {
    if (_translations.containsKey(index)) {
      setState(() {
        _showTranslation[index] = !_showTranslation[index]!;
      });
      return;
    }

    var translation = await translator.translate(text, to: "ur");
    setState(() {
      _translations[index] = translation.text;
      _showTranslation[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColor,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "User Feedback",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue.shade700,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, _backgroundColor.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Feedback List
                Expanded(
                  child: StreamBuilder(
                    stream: databaseRef.onValue,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade700,
                          ),
                        );
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: feedbackList.length,
                        itemBuilder: (context, index) {
                          final item = feedbackList[index];
                          final message = item['message'] ?? "";

                          return AnimatedPadding(
                            duration: const Duration(milliseconds: 500),
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FeedbackBubble(
                                  message: message,
                                  sender: 'user',
                                  reply: item['reply'] ?? "",
                                  shadow: true,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        _translateMessage(index, message),
                                    child: Text(
                                      _showTranslation[index] == true
                                          ? "Hide Urdu Translation"
                                          : "Show Urdu Translation",
                                    ),
                                  ),
                                ),
                                if (_showTranslation[index] == true &&
                                    _translations[index] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8),
                                    child: Text(
                                      _translations[index]!,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Input Field + Send Button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.blue.shade300],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
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
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
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
      },
    );
  }
}

import 'package:flutter/material.dart';

class FeedbackBubble extends StatelessWidget {
  final String message;
  final String sender; // "admin" or "user" or "worker"
  final String? reply;

  const FeedbackBubble({
    super.key,
    required this.message,
    required this.sender,
    this.reply, required bool shadow,
  });

  @override
  Widget build(BuildContext context) {
    bool isAdmin = sender == "admin";
    return Column(
      crossAxisAlignment:
          isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.all(12),
          constraints: BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: isAdmin ? Colors.blue.shade700 : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft:
                  isAdmin ? Radius.circular(20) : Radius.circular(0),
              bottomRight:
                  isAdmin ? Radius.circular(0) : Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(2, 3),
              )
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
                color: isAdmin ? Colors.white : Colors.blue.shade900,
                fontSize: 16),
          ),
        ),
        if (reply != null && reply!.isNotEmpty)
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              reply!,
              style: TextStyle(color: Colors.blue.shade900),
            ),
          ),
      ],
    );
  }
}

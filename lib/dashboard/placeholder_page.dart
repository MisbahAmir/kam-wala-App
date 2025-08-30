import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Center(
        child: Text(
          '$title (Placeholder)',
          style: TextStyle(fontSize: 20, color: Colors.blue.shade900, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

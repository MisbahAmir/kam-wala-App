import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String category;
  const CategoryDetailsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$category Products")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("Category", isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;

              String title = product['protitle'] ?? "No Title";
              String description = product['Description'] ?? "";
              String? imageBase64 = product['Image'];

              Uint8List? imageBytes;
              if (imageBase64 != null) {
                imageBytes = base64Decode(imageBase64);
              }

              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: imageBytes != null
                      ? Image.memory(imageBytes, width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 40),
                  title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(description),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

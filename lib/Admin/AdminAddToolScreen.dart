// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AdminAddToolScreen extends StatefulWidget {
//   const AdminAddToolScreen({super.key});

//   @override
//   State<AdminAddToolScreen> createState() => _AdminAddToolScreenState();
// }

// class _AdminAddToolScreenState extends State<AdminAddToolScreen> {
//   final nameController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final priceController = TextEditingController();
//   final imageUrlController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   Future<void> _addTool() async {
//     if (!_formKey.currentState!.validate()) return;

//     await FirebaseFirestore.instance.collection('tools').add({
//       'name': nameController.text,
//       'description': descriptionController.text,
//       'price': int.parse(priceController.text),
//       'imageUrl': imageUrlController.text,
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Tool added successfully!')));

//     nameController.clear();
//     descriptionController.clear();
//     priceController.clear();
//     imageUrlController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Add New Tool'),
//         backgroundColor: Colors.yellow,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _buildTextField(nameController, 'Tool Name'),
//               const SizedBox(height: 12),
//               _buildTextField(descriptionController, 'Description'),
//               const SizedBox(height: 12),
//               _buildTextField(priceController, 'Price (PKR)', isNumber: true),
//               const SizedBox(height: 12),
//               _buildTextField(imageUrlController, 'Image URL'),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _addTool,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.yellow,
//                   foregroundColor: Colors.black,
//                 ),
//                 child: const Text("Add Tool"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     bool isNumber = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       style: const TextStyle(color: Colors.white),
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       validator: (value) => value == null || value.isEmpty ? 'Required' : null,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white70),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.yellow),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.orange),
//         ),
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddToolScreen extends StatefulWidget {
  const AdminAddToolScreen({super.key});

  @override
  State<AdminAddToolScreen> createState() => _AdminAddToolScreenState();
}

class _AdminAddToolScreenState extends State<AdminAddToolScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child(
      'tool_images/$fileName.jpg',
    );

    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _addTool() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      final imageUrl = await _uploadImage(_selectedImage!);

      await FirebaseFirestore.instance.collection('tools').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'price': int.parse(priceController.text),
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tool added successfully!')));

      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      setState(() => _selectedImage = null);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add New Tool'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nameController, 'Tool Name'),
              const SizedBox(height: 12),
              _buildTextField(descriptionController, 'Description'),
              const SizedBox(height: 12),
              _buildTextField(priceController, 'Price (PKR)', isNumber: true),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _addTool,
                icon: const Icon(Icons.upload),
                label: Text(_isUploading ? "Uploading..." : "Add Tool"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tool Image',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              border: Border.all(color: Colors.yellow),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                _selectedImage != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    : const Center(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}

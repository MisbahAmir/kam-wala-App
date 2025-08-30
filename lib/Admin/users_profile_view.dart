import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminViewUserProfile extends StatefulWidget {
  final String userId;

  const AdminViewUserProfile({super.key, required this.userId});

  @override
  State<AdminViewUserProfile> createState() => _AdminViewUserProfileState();
}

class _AdminViewUserProfileState extends State<AdminViewUserProfile> {
  bool isBlocked = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        userData = data;
        isBlocked = (data['status'] ?? 'active') == 'blocked';
      });
    }
  }

  Future<void> toggleBlockStatus() async {
    final newStatus = isBlocked ? 'active' : 'blocked';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({'status': newStatus});
    setState(() {
      isBlocked = !isBlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F0FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = userData!['name'] ?? 'N/A';
    final email = userData!['email'] ?? 'N/A';
    final role = userData!['role'] ?? 'N/A';
    final phone = userData!['phone'] ?? 'N/A';

    final imageUrl = userData!['profileImageUrl'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0FB),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text("User Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(34),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.purple[100],
                      backgroundImage:
                          imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/pic/man.jpg')
                                  as ImageProvider,
                    ),
                    if (isBlocked)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Blocked',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40),
                profileField("Name", name),
                profileField("Email", email),
                profileField("Phone", phone),
                profileField("Role", role),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: toggleBlockStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBlocked ? Colors.green : Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    isBlocked ? "Unblock User" : "Block User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

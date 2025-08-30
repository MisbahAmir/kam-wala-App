import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kam_wala_app/Auth/login_screen.dart';

class AdminSettingsTab extends StatefulWidget {
  const AdminSettingsTab({super.key});

  @override
  State<AdminSettingsTab> createState() => _AdminSettingsTabState();
}

class _AdminSettingsTabState extends State<AdminSettingsTab> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isDarkMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  Future<void> _changePassword() async {
    final newPassword = _newPasswordController.text.trim();
    if (newPassword.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await user?.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      _newPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Text(
            "Admin Settings",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Profile Info
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user?.displayName ?? 'Admin'),
            subtitle: Text(user?.email ?? 'No Email'),
          ),

          const Divider(height: 40),

          // Theme Switch (local toggle only)
          SwitchListTile(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              // Optional: Persist theme using Provider/shared_preferences
            },
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.brightness_6),
          ),

          const Divider(height: 40),

          const Text(
            "Change Password",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter new password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isLoading ? null : _changePassword,
              ),
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

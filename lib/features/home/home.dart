// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginpage/features/auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Logout function
  Future<void> _logout(BuildContext context) async {
    // Show confirmation dialog before logging out
    bool confirmLogout = await _showLogoutConfirmation(context);
    if (confirmLogout) {
      // Log the user out from Firebase
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  // Function to display confirmation dialog
  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog and return false (cancel)
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and return true (confirm)
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Call logout function
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}

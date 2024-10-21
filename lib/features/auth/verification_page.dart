// verification_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/features/home/home.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please verify your email through the link provided in your mail.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check if the user is verified
                User? user = FirebaseAuth.instance.currentUser;
                await user?.reload();
                user = FirebaseAuth.instance.currentUser;

                if (user != null && user.emailVerified) {
                  // Navigate to the home page if email is verified
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else {
                  // Show a message if not verified yet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email not verified yet.')),
                  );
                }
              },
              child: const Text('Check Verification Status'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginpage/features/auth/google_verification_page.dart';
import 'package:loginpage/features/auth/verification_page.dart';
import 'package:loginpage/features/home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final String _errorMessage = '';
  bool _isPasswordVisible = false; // Toggles password visibility

  // Input validation and sign in
  Future<void> _signInWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackbar('Email and Password cannot be empty.');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to HomePage on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      _showSnackbar('Login Successful!');
    } catch (error) {
      _showSnackbar('Error: ${error.toString()}');
    }
  }

  // Input validation and registration
  // Future<void> _registerWithEmail() async {
  //   if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
  //     _showSnackbar('Email and Password cannot be empty.');
  //     return;
  //   }

  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomePage()),
  //     );
  //     _showSnackbar('Registration Successful!');
  //   } catch (error) {
  //     _showSnackbar('Error: ${error.toString()}');
  //   }
  // }

  Future<void> _registerWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackbar('Email and Password cannot be empty.');
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Navigate to VerificationPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerificationPage()),
      );
      _showSnackbar('Registration Successful! Verification email sent.');
    } catch (error) {
      _showSnackbar('Error: ${error.toString()}');
    }
  }

  // Google sign in
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to Google Verification Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GoogleVerificationPage()),
      );
      throw 'success';
    } catch (e) {
      throw e.toString();
    }
  }

  // Snackbar to show messages
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // Toggles visibility
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: const Text('Login with Email'),
            ),
            ElevatedButton(
              onPressed: _registerWithEmail,
              child: const Text('Sign Up with Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final response = _signInWithGoogle();
                print('===================${response.toString()}');
              },
              child: const Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

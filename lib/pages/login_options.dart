import 'package:flutter/material.dart';
import 'package:weight_plate_manager/config/router.dart';
import 'package:weight_plate_manager/pages/email_login.dart';
import 'package:weight_plate_manager/pages/home_page.dart';
import 'package:weight_plate_manager/widgets/login_button.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({super.key});

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  bool _isLoading = false;

  void _signInWithGoogle() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate Google sign-in
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to home page and remove all previous routes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              Text(
                "Signing in with Google...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign in",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Sign in with Apple
            LoginButton(
              onPressed: () {
                router.push('/signup');
              },
              icon: const Icon(Icons.apple, size: 30, color: Colors.black),
              text: "Sign in with Apple",
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 20),

            // Sign in with Google
            LoginButton(
              onPressed: () {router.go('/home');},
              icon: Image.asset(
                'assets/images/google.png',
                height: 24, // Adjust size as needed
              ),
              text: "Sign in with Google",
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 20),

            // Continue with Email
            LoginButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLoginPage()),
                  );
                },
              icon: const Icon(Icons.email, size: 30, color: Colors.black),
              text: "Continue with email",
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 10),

            // Register Option
            TextButton(
              onPressed: () {
                router.push('/signup');
              },
              child: const Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          print("Auth state changed: ${snapshot.data}");
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.hasData) {
              context.go('/home'); // Redirect to home
            } else {
              context.go('/'); // Redirect to login
            }
          });

          return const Center(child: CircularProgressIndicator()); // Show loading while navigating
        },
      ),
    );
  }
}

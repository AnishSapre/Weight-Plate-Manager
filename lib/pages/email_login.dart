import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_plate_manager/pages/home_page.dart';
import 'package:weight_plate_manager/widgets/submit_button.dart';
import 'package:weight_plate_manager/widgets/text_field_form.dart';

class EmailLoginPage extends StatelessWidget {
  EmailLoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("User signed in successfully");

      // Navigate manually to HomePage after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Error: ${e.message}",
              style: const TextStyle(color: Colors.white),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Darker background
      body: Center(
        child: SingleChildScrollView( // Added for scrollability
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Added padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fitness_center, size: 80, color: Colors.tealAccent), //Changed color
                const SizedBox(height: 20),
                Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 24, color: Colors.grey[300]), // Changed text color
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: emailController,
                  hintText: "Enter your Email",
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: "Enter your password",
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.tealAccent), //Changed color
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SubmitButton(onTap: () => signUserIn(context)),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
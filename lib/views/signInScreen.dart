// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/views/forgotPasswordScreen.dart';
import 'package:note_app/views/homeScreen.dart';
import 'package:note_app/views/signUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Login Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 300.0,
              child: Lottie.asset("assets/Animation - 1704290959847.json"),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: loginEmailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: loginPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                var loginEmail = loginEmailController.text.trim();
                var loginPassword = loginPasswordController.text.trim();

                try {
                  final User? firebaseUser = (await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: loginEmail, password: loginPassword))
                      .user;
                  if (firebaseUser != null) {
                    Get.to(() => const HomeScreen());
                  } else {}
                } on FirebaseAuthException {
                  _showErrorDialog("Incorrect Email or Password");
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const ForgotPasswordScreen());
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Forgot Password"),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const SignUpScreen());
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Don't have an account SignUp"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

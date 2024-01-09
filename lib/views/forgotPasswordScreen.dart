// ignore_for_file: file_names,avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/views/signInScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgetPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 250.0,
              child: Lottie.asset("assets/Animation - 1704290959847.json"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: forgetPasswordController,
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
            ElevatedButton(
              onPressed: () async {
                var forgotEmail = forgetPasswordController.text.trim();
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: forgotEmail)
                      .then((value) => {
                            print("Email Sent!"),
                            Get.off(() => const LoginScreen()),
                          });
                } on FirebaseAuthException catch (e) {
                  print("Error $e");
                }
              },
              child: const Text("Forgot Password"),
            ),
          ],
        ),
      ),
    );
  }
}

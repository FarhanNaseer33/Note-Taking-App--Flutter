// ignore_for_file: file_names,avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/views/homeScreen.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: noteController,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: "Add Note", border: InputBorder.none),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var title = titleController.text.trim();
          var note = noteController.text.trim();

          if (title != "" && note != "") {
            try {
              await FirebaseFirestore.instance.collection("notes").doc().set({
                "createdAt": DateTime.now(),
                "title": title,
                "note": note,
                "userId": userId?.uid,
              }).then((value) => {Get.offAll(() => const HomeScreen())});
            } catch (e) {
              print("Error $e");
            }
          }
        },
        label: const Text("Create Note"),
        icon: const Icon(Icons.note_add),
      ),
    );
  }
}

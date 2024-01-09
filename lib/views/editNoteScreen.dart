// ignore_for_file: file_names

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/views/homeScreen.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = Get.arguments['title'] ?? "";
    noteController.text = Get.arguments['note'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Note",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Title",
              ),
              controller: titleController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  labelText: "Note", border: InputBorder.none),
              controller: noteController,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("notes")
              .doc(Get.arguments['docId'].toString())
              .update(
            {
              'title': titleController.text.trim(),
              'note': noteController.text.trim(),
            },
          ).then((value) => {
                    Get.offAll(() => const HomeScreen()),
                    log("Data Updated"),
                  });
        },
        label: const Text("Update"),
        icon: const Icon(Icons.update),
      ),
    );
  }
}

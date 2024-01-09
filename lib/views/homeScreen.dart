// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:note_app/views/createNoteScreen.dart';
import 'package:note_app/views/editNoteScreen.dart';
import 'package:note_app/views/signInScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? userId = FirebaseAuth.instance.currentUser;

  final List<Color> noteColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.off(() => const LoginScreen());
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Your Recent Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("notes")
                  .where("userId", isEqualTo: userId?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong!");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Data Found!"),
                  );
                }

                if (snapshot.data != null) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var note = snapshot.data!.docs[index]['note'];
                      var docId = snapshot.data!.docs[index].id;
                      Timestamp date = snapshot.data!.docs[index]['createdAt'];
                      var finalDate = DateTime.parse(date.toDate().toString());

                      // Use modulo to repeat colors if there are more notes than colors
                      Color noteColor = noteColors[index % noteColors.length];

                      Map<String, dynamic>? documentData =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>?;

                      return GestureDetector(
                        onTap: () {
                          // when tapping on the entire note
                          // Displays a default dialog provided by the GetX library.
                          Get.defaultDialog(
                            title: documentData != null &&
                                    documentData.containsKey('title')
                                ? documentData['title']
                                : "",
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  GetTimeAgo.parse(finalDate),
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: noteColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Check if the 'title' field exists in the document data
                              if (documentData != null &&
                                  documentData.containsKey('title'))
                                Text(
                                  documentData['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                              Expanded(
                                child: Text(
                                  note,
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                GetTimeAgo.parse(finalDate),
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //edit logic is here
                                      Get.to(
                                        () => const EditNoteScreen(),
                                        arguments: {
                                          'note': note,
                                          'docId': docId,
                                          'title': documentData != null
                                              ? documentData['title']
                                              : "",
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  GestureDetector(
                                    onTap: () async {
                                      //delete logic is here
                                      await FirebaseFirestore.instance
                                          .collection("notes")
                                          .doc(docId)
                                          .delete();
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const CreateNoteScreen());
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

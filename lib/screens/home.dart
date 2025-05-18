import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import '../services/firestore.dart';

final FirestoreService firestoreService = FirestoreService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void openNoteBox({String? docID, String? existingText}) {
    textController.text = existingText ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? 'Add Note' : 'Update Note'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter your note here'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final text = textController.text.trim();
                Navigator.pop(context);

                // Decide whether to add or update
                if (docID == null) {
                  firestoreService.addNote(text);
                } else {
                  firestoreService.updateNote(docID, text);
                }
                // Reset the form
                textController.clear();
              }
            },
            child: Text(docID == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    ).then((_) {
      // Reset if user taps outside dialog
      textController.clear();
    });
  }

  void openNotificationTestScreen() {
    Navigator.pushNamed(context, 'notification');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  tooltip: 'Notification Test',
                  onPressed: openNotificationTestScreen,
                ),
              ],
            ),
            body: StreamBuilder(
              stream: firestoreService.getNotesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No notes available.'));
                } else {
                  List notesList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = notesList[index];
                      String docID = document.id;
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String noteText = data['note'];
                      return ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () => openNoteBox(docID: docID, existingText: noteText),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => firestoreService.deleteNote(docID),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => openNoteBox(),
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
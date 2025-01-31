import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/NotesModel.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(labelText: "Subtitle"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    subtitleController.text.isNotEmpty) {
                  Notes newNote = Notes(
                    title: titleController.text,
                    description: subtitleController.text,
                  );

                  List<String> notesList =
                      sharedPreferences.getStringList('list') ?? [];
                  notesList.add(jsonEncode(newNote.toMap()));
                  sharedPreferences.setStringList('list', notesList);

                  Get.back(result: 'loadData');
                }
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}

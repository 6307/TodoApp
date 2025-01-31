import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/NotesModel.dart';

class HomeController extends GetxController {
  RxList<Notes> notesList = <Notes>[].obs; // Observable list of notes

  late SharedPreferences sharedPreferences;

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? stringList = sharedPreferences.getStringList('list');

    if (stringList != null) {
      notesList.value =
          stringList.map((item) => Notes.fromMap(jsonDecode(item))).toList();
    }
  }

  deleteNote(int index) {
    notesList.removeAt(index);
    saveNotes();
  }

  updateNote(int index, String newTitle, String newSubtitle) {
    Notes updatedNote = Notes(title: newTitle, description: newSubtitle);
    notesList[index] = updatedNote;
    saveNotes();
  }

  saveNotes() {
    List<String> stringList =
        notesList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList("list", stringList);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/NotesModel.dart';
import '../ViewModel/notesController.dart';
import 'addScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    // Fetch data when the screen is loaded
    controller.getData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.notesList.isEmpty
            ? const Center(child: Text("Empty"))
            : ListView.builder(
                itemCount: controller.notesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('$index'),
                    ),
                    title: Text(controller.notesList[index].title),
                    subtitle: Text(controller.notesList[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Edit Note",
                              content: Column(
                                children: [
                                  TextField(
                                    controller: TextEditingController(
                                        text:
                                            controller.notesList[index].title),
                                    decoration: const InputDecoration(
                                        labelText: 'Title'),
                                    onChanged: (value) {
                                      controller.notesList[index].title = value;
                                    },
                                  ),
                                  TextField(
                                    controller: TextEditingController(
                                        text: controller
                                            .notesList[index].description),
                                    decoration: const InputDecoration(
                                        labelText: 'Description'),
                                    onChanged: (value) {
                                      controller.notesList[index].description =
                                          value;
                                    },
                                  ),
                                ],
                              ),
                              confirm: ElevatedButton(
                                onPressed: () {
                                  controller.updateNote(
                                    index,
                                    controller.notesList[index].title,
                                    controller.notesList[index].description,
                                  );
                                  Get.back(); // Close the dialog
                                },
                                child: const Text("Save"),
                              ),
                              cancel: ElevatedButton(
                                onPressed: () => Get.back(), // Close dialog
                                child: const Text("Cancel"),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.deleteNote(index); // Delete note
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String refresh = await Get.to(const AddScreen());
          if (refresh == 'loadData') {
            controller.getData(); // Reload data after adding a new note
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

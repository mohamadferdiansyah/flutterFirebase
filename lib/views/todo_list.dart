import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firebase.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Mengambil Fungsi dari service
  final FirestoreService firestoreService = FirestoreService();

  // Controller Form Input Data
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Form input data

  void openAlertBox({String? todoId, String? title, String? description}) {
    if (todoId != null) {
      _judulController.text = title!;
      _deskripsiController.text = description!;
    } else {
      _judulController.clear();
      _deskripsiController.clear();
    }

    final formKey = GlobalKey<FormState>();

    // Menampilkan dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title:
                todoId != null
                    ? const Text("Edit Todo")
                    : const Text("Tambah Todo"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(labelText: "Judul"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Judul tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _judulController.clear();
                  _deskripsiController.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.brown),
                ),
                onPressed: () {
                  if (_judulController.text.isEmpty ||
                      _deskripsiController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Judul dan Deskripsi tidak boleh kosong"),
                      ),
                    );
                    Navigator.pop(context);
                    return;
                  }
                  if (todoId != null) {
                    firestoreService.updateTodos(
                      todoId,
                      _judulController.text,
                      _deskripsiController.text,
                    );
                  } else {
                    firestoreService.addTodos(
                      _judulController.text,
                      _deskripsiController.text,
                    );
                  }
                  _judulController.clear();
                  _deskripsiController.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // pop up dialog hapus

  void openDeleteAlertBox(String todoId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Todo"),
            content: const Text("Apakah anda yakin ingin menghapus todo ini?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  firestoreService.deleteTodos(todoId);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo-List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List todoList = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  // mengambil data per id
                  DocumentSnapshot document = todoList[index];
                  String todoId = document.id;

                  // mengambil data dari tiap id
                  Map<String, dynamic> todoData =
                      document.data() as Map<String, dynamic>;
                  String title = todoData['title'];
                  String description = todoData['description'];

                  return Card(
                    child: ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.brown),
                            onPressed: () {
                              openAlertBox(
                                todoId: todoId,
                                title: title,
                                description: description,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              openDeleteAlertBox(todoId);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAlertBox();
        },
        backgroundColor: Colors.brown,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

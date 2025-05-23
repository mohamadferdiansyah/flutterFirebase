import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  
  // Menyambungkan project kita dengan firestore
  final CollectionReference todos = 
      FirebaseFirestore.instance.collection("todos");

  // Create Data Todo
  Future<void> addTodos(String title, String description) {
    return todos.add({
      "title": title, 
      "description": description, 
      "timestamp": DateTime.now()
    });
  }

  // get Data Todo
  Stream<QuerySnapshot> getTodos() {
    final steramTodos = todos.orderBy("timestamp", descending: true).snapshots();
    return steramTodos;
  }

  // update data todo

  Future<void> updateTodos(
    String id,
    String title,
    String description,
  ) {
    return todos.doc(id).update({
      "title": title,
      "description": description,
      "timestamp": DateTime.now()
    });
  }

  // delete data todo

  Future<void> deleteTodos(String id) {
    return todos.doc(id).delete();
  }
}
import 'package:flutter/material.dart';

class DetailTodo extends StatefulWidget {
  final String? todoId;
  final String? todoTitle;
  final String? todoDescription;

  const DetailTodo({
    super.key,
    required this.todoId,
    required this.todoTitle,
    required this.todoDescription,
  });

  @override
  State<DetailTodo> createState() => _DetailTodoState();
}

class _DetailTodoState extends State<DetailTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Todo", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul Todo", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                widget.todoTitle!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Text("Deskripsi Todo", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                widget.todoDescription!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

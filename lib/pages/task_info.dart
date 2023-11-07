import 'package:flutter/material.dart';
import 'package:todo_list/components/task.dart';

class TaskInfoPage extends StatefulWidget {
  const TaskInfoPage({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskInfoPage> createState() => _TaskInfoPageState();
}

class _TaskInfoPageState extends State<TaskInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Information"),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                widget.task.getMessage(),
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

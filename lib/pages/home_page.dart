import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/components/task.dart';
import 'package:todo_list/pages/task_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  List<Task> taskList = <Task>[];

  Future<void> _initPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    int taskListSize = prefs.getInt('taskListSize')!;

    setState(() {
      for (int i = 0; i < taskListSize; i++) {
        taskList.add(
          Task(
            message: prefs.getString('message$i')!,
            completion: prefs.getBool('completion$i')!,
          ),
        );
      }
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < taskList.length; i++) {
      prefs.setString('message$i', taskList[i].getMessage());
      prefs.setBool('completion$i', taskList[i].getCompletion());
    }
    prefs.setInt('taskListSize', taskList.length);
  }

  Future<void> _removeTask(int taskIndex) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (taskIndex < taskList.length) {
        prefs.remove('message$taskIndex');
        prefs.remove('completion$taskIndex');
      }
    });
    _saveState();
  }

  @override
  void initState() {
    super.initState();
    _initPersistence();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      String msg = controller.text;
                      if (msg != '') {
                        taskList.add(
                            Task(completion: false, message: controller.text));
                      }
                    });
                    controller.clear();
                    _saveState();
                  },
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade400),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  Task task = taskList[index];
                  return Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              task.setCompletion(!task.getCompletion());
                            });
                            _saveState();
                          },
                          icon: (task.getCompletion())
                              ? const Icon(Icons.check_circle_rounded)
                              : const Icon(Icons.circle_outlined)),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            task.getMessage(),
                            style: (task.getCompletion())
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough)
                                : const TextStyle(
                                    decoration: TextDecoration.none),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TaskInfoPage(task: task)),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            taskList.remove(task);
                          });
                          _removeTask(index);
                        },
                        icon: Icon(
                          Icons.highlight_remove,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
  List<Todo> taskList = [];

  void _addToDb() async {
    String task = textController.text;
    int id = await DatabaseHelper.instance.insert(Todo(title: task));
    setState(() {
      taskList.insert(0, Todo(id: id, title: task));
    });
  }

  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      taskList.removeWhere((element) => element.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        for (var element in value) {
          taskList.add(Todo(id: element['id'], title: element["title"]));
        }
      });
    }).catchError((error) {
      // ignore: avoid_print
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "Enter a task"),
                    controller: textController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addToDb,
                ),
                const SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: Container(
                child: taskList.isEmpty
                    ? Container()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: taskList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(taskList[index].title),
                            leading: Text(taskList[index].id.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(taskList[index].id!),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

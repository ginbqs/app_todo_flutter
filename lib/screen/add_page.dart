import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing/service/todo_service.dart';
import 'package:testing/util/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (widget.todo != null) {
      setState(() {
        isEdit = true;
        final title = todo!['title'];
        final description = todo!['description'];

        titleController.text = title;
        descriptionController.text = description;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoApp"),
        actions: const [],
        backgroundColor: Colors.grey[800],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.grey[800],
                ),
              ))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      showErrorMessage(context, message: 'Not found');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final response = await TodoService.updateTodo(id, body);

    if (response) {
      showSuccessMessage(context, message: 'Update success');
    } else {
      showErrorMessage(context, message: 'Update error');
    }
  }

  void submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title == '' || description == '') {
      showErrorMessage(context, message: 'Title and description are required');
      return;
    }

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final response = await TodoService.addTodo(body);

    if (response) {
      showErrorMessage(context, message: 'Creation success');
    } else {
      showErrorMessage(context, message: 'Creation error');
    }
  }
}

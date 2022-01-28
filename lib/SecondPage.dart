// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print, unnecessary_new

import 'dart:convert';

import "package:flutter/material.dart";
import "package:flutter_datetime_picker/flutter_datetime_picker.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/FirstPage.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key? key}) : super(key: key);
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String name = "";
  String description = "";
  String taskPriority = "Low";
  String taskStatus = "Not Started";
  String taskCategory = "Personal";
  bool isDateEdited = false;
  DateTime dateOfTask = DateTime.now();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  addTask() async {
    final SharedPreferences prefs = await _prefs;
    if (name.isEmpty || description.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
    } else {
      String todos = prefs.getString("todos") ?? "[]";
      List<Map<String, dynamic>> todoList =
          new List<Map<String, dynamic>>.from(jsonDecode(todos));
      todoList.add({
        "name": name,
        "description": description,
        "taskPriority": taskPriority,
        "taskStatus": taskStatus,
        "taskCategory": taskCategory,
        "dateOfTask": dateOfTask.toString(),
      });
      prefs.setString("todos", json.encode(todoList));
      Fluttertoast.showToast(msg: "Task added successfully");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: SafeArea(
              child: ListView(
        children: [
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Task",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Task Name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextField(
                  minLines: 10,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Task Description",
                  ),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Date",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2022, 1, 1),
                              maxTime: DateTime(2030, 12, 12),
                              onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              dateOfTask = date;
                              isDateEdited = true;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          isDateEdited ? 'Date Picked' : 'Pick Date',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Priority",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      items: <String>['Low', 'Medium', 'High', 'Urgent']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: taskPriority,
                      onChanged: (val) {
                        setState(() {
                          taskPriority = val!;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Status",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      items: <String>['Not Started', 'In Progress', 'Completed']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: taskStatus,
                      onChanged: (val) {
                        setState(() {
                          taskStatus = val!;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Category",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      items: <String>['Personal', 'Work', 'School', 'Shop']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: taskCategory,
                      onChanged: (val) {
                        setState(() {
                          taskCategory = val!;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text("Add Task"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        return Color(0xFF00C569);
                      },
                    ),
                    foregroundColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        return Color(0xFFFFFFFF);
                      },
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                ),
              )
            ],
          ),
        ],
      ))),
    );
  }
}

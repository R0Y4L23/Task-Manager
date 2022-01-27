// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_new, unused_field, must_call_super

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./SecondPage.dart";

class FirstPage extends StatefulWidget {
  FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, dynamic>> _todos = [];
  List<Color> colors = [
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.red.shade50,
    Colors.yellow.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.pink.shade50,
    Colors.cyan.shade50
  ];

  getTodos() async {
    final SharedPreferences prefs = await _prefs;
    final String todos = prefs.getString('todos') ?? '';
    setState(() {
      _todos = new List<Map<String, dynamic>>.from(jsonDecode(todos));
    });
  }

  setTodosInLocalStorage(td) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('todos', jsonEncode(td));
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Tasks",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondPage()),
                      );
                    },
                  ),
                ],
              )),
          _todos.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    String pending = "";

                    if (DateTime.now()
                        .isAfter(DateTime.parse(_todos[index]['dateOfTask']))) {
                      pending = "Pending";
                    } else {
                      pending = "";
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            _todos[index]['name'],
                            style: TextStyle(
                                fontSize: 25,
                                decoration:
                                    _todos[index]['taskStatus'] == "Completed"
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              _todos[index]['description'],
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration:
                                      _todos[index]['taskStatus'] == "Completed"
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(_todos[index]['dateOfTask']
                                        .substring(8, 10) +
                                    "/" +
                                    _todos[index]['dateOfTask']
                                        .substring(5, 7) +
                                    "/" +
                                    _todos[index]['dateOfTask']
                                        .substring(0, 4)),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  child: Text(
                                    _todos[index]['taskPriority'].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _todos[index]['taskPriority'] ==
                                                "Low"
                                            ? Colors.green
                                            : _todos[index]['taskPriority'] ==
                                                    "Medium"
                                                ? Colors.yellow
                                                : _todos[index]
                                                            ['taskPriority'] ==
                                                        "High"
                                                    ? Colors.red
                                                    : Colors.purple),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _todos[index]
                                          ['taskPriority'] = _todos[index]
                                                  ['taskPriority'] ==
                                              "Low"
                                          ? "Medium"
                                          : _todos[index]['taskPriority'] ==
                                                  "Medium"
                                              ? "High"
                                              : _todos[index]['taskPriority'] ==
                                                      "High"
                                                  ? "Urgent"
                                                  : _todos[index][
                                                              'taskPriority'] ==
                                                          "Urgent"
                                                      ? "Low"
                                                      : "Low";

                                      setTodosInLocalStorage(_todos);
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  child: Text(_todos[index]['taskStatus']),
                                  onTap: () {
                                    setState(() {
                                      _todos[index]['taskStatus'] =
                                          _todos[index]['taskStatus'] ==
                                                  "Not Started"
                                              ? "In Progress"
                                              : _todos[index]['taskStatus'] ==
                                                      "In Progress"
                                                  ? "Completed"
                                                  : _todos[index]
                                                              ['taskStatus'] ==
                                                          "Completed"
                                                      ? "Not Started"
                                                      : "Not Started";

                                      setTodosInLocalStorage(_todos);
                                    });
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              Icon(
                                _todos[index]['taskCategory'] == "Work"
                                    ? Icons.work
                                    : _todos[index]['taskCategory'] ==
                                            "Personal"
                                        ? Icons.home
                                        : _todos[index]['taskCategory'] ==
                                                "Shop"
                                            ? Icons.shopping_cart
                                            : _todos[index]['taskCategory'] ==
                                                    "School"
                                                ? Icons.school
                                                : Icons.error,
                                size: 15,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                _todos[index]['taskCategory'],
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                pending.toUpperCase(),
                                style: TextStyle(color: Colors.red),
                              )
                            ]),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        tileColor: colors[Random().nextInt(colors.length)],
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _todos.removeAt(index);
                              setTodosInLocalStorage(_todos);
                            });
                          },
                        ),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    );
                  },
                  itemCount: _todos.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                )
              : Center(
                  child: Text(
                  "No Tasks Added Yet",
                  style: TextStyle(fontSize: 30),
                )),
        ],
      ),
    ));
  }
}

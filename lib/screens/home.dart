// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:todo/constants/colors.dart';
import '../models/todo.dart';
import '../widgets/todo_items.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoControllerTitle = TextEditingController();
  final _todoControllerDesc = TextEditingController();
  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                serachBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          "Your Plans",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItems(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // _addToDoItem(_todoController.text);
                    openDialog();
                  },
                  child: Text(
                    "+",
                    style: TextStyle(fontSize: 40),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              )

              // Expanded(
              //   child: Container(
              //     margin: EdgeInsets.only(
              //       bottom: 20,
              //       right: 20,
              //       left: 20,
              //     ),
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 20,
              //       vertical: 5,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       boxShadow: const [
              //         BoxShadow(
              //           color: Colors.grey,
              //           offset: Offset(0.0, 0.0),
              //           blurRadius: 10.0,
              //           spreadRadius: 0.0,
              //         ),
              //       ],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: TextField(
              //       controller: _todoControllerTitle,
              //       decoration: InputDecoration(
              //           hintText: "Create Goals", border: InputBorder.none),
              //     ),
              //   ),
              // ),

              )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((element) => element.id == id);
    });
  }

  void _addToDoItem(String toDoTitle, String toDoDescription) {
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoTitle: toDoTitle,
          todoDesc: toDoDescription));
    });
    _todoControllerTitle.clear();
    _todoControllerDesc.clear();
  }

  void openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            scrollable: true,
            title: const Text("Add Your Goals"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _todoControllerTitle,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextFormField(
                      controller: _todoControllerDesc,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1, //Normal textInputField will be displayed
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                child: ElevatedButton(
                  child: const Text("Add"),
                  onPressed: () {
                    // your code
                    _addToDoItem(
                        _todoControllerTitle.text, _todoControllerDesc.text);
                  },
                ),
              ),
            ],
          ));

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((element) => element.todoTitle!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget serachBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          // prefixIconConstraints:
          //     BoxConstraints(maxHeight: 25, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: tdGrey,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          // decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpeg')),
        ),
      ]),
    );
  }
}

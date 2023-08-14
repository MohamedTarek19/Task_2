import 'package:flutter/material.dart';
import 'package:task_two/view/home_screen.dart';
import 'package:task_two/models/todo_model.dart';
import 'package:task_two/view_models/todo_vm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home:  HomePage(),
    );
  }
}




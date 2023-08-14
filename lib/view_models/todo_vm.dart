import 'dart:convert';

import 'package:task_two/models/todo_model.dart';
import "package:http/http.dart" as http;
class ToDoVm{

  Future<List<ToDo>?> getToDoList() async {
    Uri url = Uri.parse('https://dummyjson.com/todos');

    var response = await http.get(url);
    if(response.statusCode == 200){
      //print("${response.body}\n");
      var body = jsonDecode(response.body)['todos'] as List;
      List<ToDo>? todoList = [];
      for(var b in body){
        // print(b.key);
        todoList.add(ToDo.fromJson(b));
        //print(b);
      }
      return todoList;
    }
    return null;
  }

}
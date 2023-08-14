class ToDo {
  String? todo;
  int? id;
  bool? completed;

  ToDo({this.id, this.todo, this.completed});



  factory ToDo.fromJson(Map<String, dynamic> json){
    return ToDo(
      id: json['id'],
      todo: json['todo'] as String?,
      completed: json['completed'] as bool?,
    );
  }
}

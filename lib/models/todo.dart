class ToDo {
  String? id;
  String? todoTitle;
  String? todoDesc;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoTitle,
    required this.todoDesc,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [];
  }
}

class Todo {
  int? id;
  String title;

  Todo({ this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}

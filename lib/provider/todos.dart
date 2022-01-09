import 'package:flutter/material.dart';
import 'package:flutterhf/api/firebase.dart';
import 'package:flutterhf/views/widgets/todo.dart';

class TodosProvider extends ChangeNotifier {
  void addTodo(Todo todo) {
    FirebaseApi.createTodo(todo);
  }

  void removeTodo(Todo todo) {
    FirebaseApi.deleteTodo(todo);
  }

  void removeWhereNotLiked() {
    FirebaseApi.deleteNotLiked();
    //_todos.removeWhere((todo) => todo.liked == false);
    //notifyListeners();
  }

  void updateLiked(Todo todo) {
    FirebaseApi.likeChangedTodo(todo);
  }

  // List<Todo> get todos =>
  //_todos.where((todo) => todo.title.isEmpty == false).toList();
}

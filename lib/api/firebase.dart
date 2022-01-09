import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterhf/views/widgets/todo.dart';

class FirebaseApi {
  static Future createTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc();

    await docTodo.set(todo.toJson());
  }

  static Future deleteTodo(Todo todo) async {
    final collection = FirebaseFirestore.instance.collection('todo');
    var snapshot = await collection
        .where('liked', isEqualTo: todo.liked)
        .where('title', isEqualTo: todo.title)
        .where('hour', isEqualTo: todo.hour)
        .where('isRecipe', isEqualTo: todo.isRecipe)
        .where('ingredients', isEqualTo: todo.ingredients)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
      break;
    }
  }

  static Future likeChangedTodo(Todo todo) async {
    final collection = FirebaseFirestore.instance.collection('todo');
    var snapshot = await collection
        .where('liked', isEqualTo: todo.liked)
        .where('title', isEqualTo: todo.title)
        .where('hour', isEqualTo: todo.hour)
        .where('isRecipe', isEqualTo: todo.isRecipe)
        .where('ingredients', isEqualTo: todo.ingredients)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.update(todo.toJson());
      break;
    }
  }

  static Future deleteNotLiked() async {
    final collection = FirebaseFirestore.instance.collection('todo');
    var snapshot = await collection.where('liked', isEqualTo: false).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}

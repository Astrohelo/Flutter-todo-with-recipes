import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterhf/provider/todos.dart';
import 'package:provider/provider.dart';

import '../../common.dart';

class Todo extends StatefulWidget {
  final String title;
  final String hour;
  late bool liked;
  late bool isRecipe;
  late String ingredients;

  Todo(
      {required this.title,
      required this.hour,
      required this.liked,
      required this.isRecipe,
      required this.ingredients,
      Key? key})
      : super(key: key);

  @override
  State<Todo> createState() => _TodoState();
  static Todo fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        hour: json['hour'],
        ingredients: json['ingredients'],
        isRecipe: json['isRecipe'],
        liked: json['liked'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'hour': hour,
        'ingredients': ingredients,
        'isRecipe': isRecipe,
        'liked': liked,
      };
}

class _TodoState extends State<Todo> {
  _pressedheart() {
    var newVal = true;
    if (widget.liked) {
      newVal = false;
    } else {
      newVal = true;
    }
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.updateLiked(widget);
    setState(() {
      widget.liked = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Container(
      constraints: const BoxConstraints(
        minWidth: 300,
        minHeight: 70,
        maxWidth: 600,
        maxHeight: 150,
      ),
      child: Card(
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.brown, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                ),
                color: widget.liked ? Colors.red : Colors.grey,
                onPressed: () => _pressedheart(),
                splashRadius: 15,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  widget.isRecipe
                      ? TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(l10n!.ingredients),
                              content: Text(widget.ingredients),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, l10n.ok),
                                  child: Text(l10n.ok),
                                ),
                              ],
                            ),
                          ),
                          child: Text(l10n!.ingredients,style: const TextStyle(color: Colors.amberAccent),),
                        )
                      : Container(),
                ],
              ),
              const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete_forever,
                    ),
                    color: Colors.red,
                    onPressed: () => deleteTodo(context, widget),
                    splashRadius: 15,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Icon(
                          Icons.schedule,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 12.0, bottom: 12.0),
                        child: Text(
                          '${widget.hour} ' + l10n!.todoTime,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);
  }
}

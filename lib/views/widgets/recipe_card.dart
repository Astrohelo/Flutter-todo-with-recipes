import 'package:flutter/material.dart';
import 'package:flutterhf/provider/todos.dart';
import 'package:flutterhf/views/widgets/todo.dart';
import 'package:provider/provider.dart';

import '../../common.dart';

class RecipeCard extends StatefulWidget {
  final String title;
  final String img;
  final String ingredients;
  final String time;
  RecipeCard({
    required this.title,
    required this.img,
    required this.ingredients,
    required this.time,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(widget.img),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              backgroundColor: Colors.greenAccent,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              addToTodo(widget.title, widget.time);
            },
            child: Text(l10n!.addRecipe),
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(l10n.ingredients),
                        content: Text(widget.ingredients),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, l10n.ok),
                            child: Text(l10n.ok),
                          ),
                        ],
                      ),
                    ),
                    child: Text(
                      l10n.ingredients,
                      style: TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 12.0, bottom: 12.0),
                        child: Text(
                          '${widget.time} ' + l10n.todoTime,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }

  void addToTodo(String title, String time) {
    final todo = Todo(
      title: title,
      hour: time,
      liked: false,
      isRecipe: true,
      ingredients: widget.ingredients,
    );

    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.addTodo(todo);
    setState(() {});
  }
}

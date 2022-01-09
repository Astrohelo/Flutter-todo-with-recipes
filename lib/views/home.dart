import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterhf/provider/todos.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import 'widgets/number_scroll.dart';
import 'widgets/recipe_screen.dart';
import 'widgets/todo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final titleController = TextEditingController();
  final timeController = TextEditingController();

  var liked = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu),
            const SizedBox(
              width: 10,
            ),
            Text(l10n!.homeTitle),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: ExactAssetImage(
              'assets/images/background.jpg',
            ),
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  color: Colors.lightBlue[500],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                              ),
                              color: liked ? Colors.red : Colors.grey,
                              onPressed: () => _pressedheart(),
                              splashRadius: 15,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),

                              child: TextFormField(
                                controller: titleController,
                                maxLength: 20,
                                onTap: () {},
                                //onFieldSubmitted: ,
                                decoration: InputDecoration(
                                  labelText: l10n.formTitle,
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                                onFieldSubmitted: (String? value) {
                                  addTodo(titleController.text,
                                      timeController.text, liked);
                                  titleController.text = "";
                                },
                              ),
                              //NumberScroll(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: NumberScroll(
                              controller: timeController,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                addTodo(titleController.text,
                                    timeController.text, liked);
                                titleController.text = "";
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.deepPurple,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Hero(
                              tag: 'recipeHero',
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    primary: Colors.white,
                                    backgroundColor: Colors.amber,
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const RecipeScreen();
                                    }));
                                  },
                                  child: Text(l10n.formRecipes),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  primary: Colors.white,
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: resetTodos,
                                child: Text(l10n.formReset),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('todo')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      else{
                      return ListView.builder(
                          itemCount: streamSnapshot.data?.docs.length,
                          itemBuilder: (_, index) => Todo(
                                hour: streamSnapshot.data!.docs[index]['hour'],
                                ingredients: streamSnapshot.data!.docs[index]
                                    ['ingredients'],
                                isRecipe: streamSnapshot.data!.docs[index]
                                    ['isRecipe'],
                                liked: streamSnapshot.data!.docs[index]
                                    ['liked'],
                                title: streamSnapshot.data!.docs[index]
                                    ['title'],
                              ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Future getTodos() async {
    var firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot<Map<String, dynamic>>> qn =
        await firestore.collection("todo").snapshots();
        qn.forEach((element) {element.fromJson(element)})
  }*/

  void addTodo(String title, String time, bool liked) {
    final todo = Todo(
      title: title,
      hour: time,
      liked: liked,
      isRecipe: false,
      ingredients: "",
    );

    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.addTodo(todo);
    setState(() {});
  }

  void resetTodos() {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeWhereNotLiked();
    setState(() {});
  }

  void _pressedheart() {
    var newVal = true;
    if (liked) {
      newVal = false;
    } else {
      newVal = true;
    }
    setState(() {
      liked = newVal;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    titleController.dispose();
    timeController.dispose();
    super.dispose();
  }
}

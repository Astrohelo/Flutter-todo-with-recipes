import 'package:flutter/material.dart';
import 'package:flutterhf/model/recipe.api.dart';
import 'package:flutterhf/model/recipe.dart';
import 'package:flutterhf/provider/todos.dart';
import 'package:flutterhf/views/widgets/todo.dart';
import 'package:provider/provider.dart';

import '../../common.dart';
import 'recipe_card.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final searchController = TextEditingController();
  late List<Recipe> _recipes;
  bool _isLoading = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getRecipes(String searchText) async {
    _recipes = await RecipeApi.getRecipe(searchText);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(
              width: 10,
            ),
            Text(l10n!.recipePageTitle),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: ExactAssetImage(
              'assets/images/foodBackground.jpg',
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
              children: [
                Card(
                  color: Colors.lightBlue[500],
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),

                          child: TextFormField(
                            controller: searchController,
                            maxLength: 20,
                            onTap: () {},
                            //onFieldSubmitted: ,
                            decoration: InputDecoration(
                              labelText: l10n.formTitle,
                              labelStyle: const TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                            onFieldSubmitted: (String? value) {
                              getRecipes(searchController.text);
                            },
                          ),
                          //NumberScroll(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.search_sharp),
                          onPressed: () {
                            getRecipes(searchController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Hero(
                            tag: 'recipeHero',
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                primary: Colors.white,
                                backgroundColor: Colors.blueGrey[200],
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(l10n.backButton),
                            )),
                      ),
                    ]),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _recipes.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(
                              title: _recipes[index].name,
                              img: _recipes[index].img,
                              ingredients: _recipes[index].ingredients,
                              time: _recipes[index].time,
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

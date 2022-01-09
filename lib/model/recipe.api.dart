import 'dart:convert';
import 'package:http/http.dart' as http;

import 'recipe.dart';

class RecipeApi {
  final List<Recipe> recipes = [];
  static Future<List<Recipe>> getRecipe(String food) async {

    final response = await http.get(Uri.parse(
        "https://api.edamam.com/search?q=$food&app_id=&app_key="));

    Map data = jsonDecode(response.body);
    List<Recipe> _temp = [];

    for (var i in data['hits']) {
      _temp.add(Recipe(
        name: i['recipe']['label'],
        img: i['recipe']['image'],
        ingredients: i['recipe']['ingredientLines'].toString(),
        time: i['recipe']['totalTime'].toString(),
      ));
    }
    // ignore: avoid_print

    return _temp;
  }
}

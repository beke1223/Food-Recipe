import 'dart:convert';
import 'package:food_recipe/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    // var uri = Uri.https('ymmly2.p.rapidapi.comu', '/feeds/list',
    var uri = Uri.https('tasty.p.rapidapi.com', '/feeds/list',
        {"limit": "18", "start": "0", "tag": "list.recipe.popular"});

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "adc06a41bamshd4754e6ec827877p141378jsnc2fbabf2127d",
      // "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "x-rapidapi-host": "tasty.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List<Map<String, dynamic>> _temp = [];
    List<dynamic> Ingredients = [];
    List<dynamic> Ingredients_ind = [];
// print("data decoded");
// print(data);

    for (var i in data['results']) {
      //  print("***************");
      if (i['item'] != null) {
        //  print(i['item']);
        //  print(i['item']['name']);
        //  print(i['item']['description']);
        //  print(i['item']['thumbnail_url']);
        //  print(i['item']['total_time_minutes']);
        //  print(i['item']['original_video_url']);
        //  print(i['item']['user_ratings']!=null?i['item']['user_ratings']['count_positive']:"not rated");
        print("Section list +++++++++++++++++++++++++++");

        if (i['item']['sections'] != null) {
          print(i['item']['sections'][0]['components']);
          Ingredients_ind = i['item']['sections'][0]['components'];
          for (var inst in i['item']['sections']) {
            // print(inst['components'][0]);
            // print('section $inst');
            // print(inst[0]);
            for (var ing in inst['components']) {
              // print(ing['raw_text']);
              // Ingredients_ind.add(ing['raw_text']);
            }
          }

          print("Section list +++++++++++++++++++++++++++");
          // print(i['item']['instructions']);
          _temp.add(
            {
              "name": i['item']['name'],
              "description": i['item']['description'],
              "image": i['item']['thumbnail_url'],
              "total_time": i['item']['total_time_minutes'] ?? "have no time",
              "original_video":
                  i['item']['original_video_url'] ?? "have not video",
              "rating": i['item']['user_ratings'] != null
                  ? i['item']['user_ratings']['count_positive']
                  : "not rated",
              "instruction": i['item']['instructions'],
              "ingredients": Ingredients_ind
            },
          );
        }
        print(
            "======================================================================");
        print(Ingredients_ind);
        print(
            "======================================================================");
      }
    }
    return Recipe.recipesFromSnapshot(_temp);
  }
}

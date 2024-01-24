import 'package:flutter/material.dart';
import 'package:food_recipe/models/recipe.api.dart';
import 'package:food_recipe/models/recipe.dart';
import 'package:food_recipe/views/pages/detailed_recipe.dart';
import 'package:food_recipe/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


//TODO: when food item is clicked redirect user to page where the recipes can be found

class _HomePageState extends State<HomePage> {
  late List<Recipe> _recipes;

  bool _isLoading = true;
  late List<Recipe> _filteredRecipe ;
  @override
  void initState() {
    super.initState();
    getRecipes();
    
  }
 
  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    _filteredRecipe=_recipes;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(width: 10),
              Text('Food Recipe'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _filteredRecipe = _recipes
                          .where((element) => element.name
                              .toLowerCase()
                              .startsWith(value.toLowerCase()))
                          .toList();
                    });
                  },
                  
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search ...",
                  ),
                ),
                
              ),
            ), const SizedBox(height:10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  :  ListView.builder(
                      itemCount: _filteredRecipe.length,
                      itemBuilder: (context, index) {
                        return  GestureDetector(
                          child: RecipeCard(
                              title: _filteredRecipe[index].name,
                              cookTime: _filteredRecipe[index].totalTime,
                              rating: _filteredRecipe[index].rating.toString(),
                              thumbnailUrl: _filteredRecipe[index].images),
                              onTap: ()=>{
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>   RecipeDetails(recipe: _filteredRecipe[index])),) 
                              },
                        ) ;
                      },
                    ) 
            ),
          ],
        ));
  }
}

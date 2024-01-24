class Recipe {
  final String name;
  final String images;
  final String rating;
  final String totalTime;
  String url;
  dynamic instruction;
  dynamic ingredients;

  Recipe({required this.ingredients, required this.instruction, required this.name, required this.images, required this.rating, required this.totalTime,required this.url});

  factory Recipe.fromJson(dynamic json) {
    print(json);
    return Recipe(
        name: json['name'] as String,
        images: json['image'] as String,
        rating: json['rating'].toString(),
        totalTime: json['total_time'].toString() ,
        url:json['original_video'].toString(),
        instruction: json['instruction'],
        ingredients: json['ingredients'],
        );
        
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime}';
  }
}
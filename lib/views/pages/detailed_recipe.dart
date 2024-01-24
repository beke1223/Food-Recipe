import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../models/expansionModel.dart';
import '../../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';

class RecipeDetails extends StatefulWidget {
 
  Recipe recipe;
 
  RecipeDetails({required this.recipe});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late InAppWebViewController webViewController;
  late VideoPlayerController _controller;

  Future<void>? _initializeVideoPlayerFutrue;
  late List<Item> data;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.recipe.url));
    _initializeVideoPlayerFutrue = _controller.initialize();
    _controller.play();
    _controller.setLooping(true);

    data = [
      Item(
          headerText: "Instructions",
          expandedBody: Expanded(
            child: SizedBox(
                height: 400,
                child: widget.recipe.instruction != null
                    ? ListView.builder(
                        itemCount: widget.recipe.instruction.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                "${index + 1}. ${widget.recipe.instruction[index]['display_text']}",
                                style: const TextStyle(
                                    color: Colors.black, wordSpacing: 3),
                              ),
                            ),
                          );
                        })
                    : const Text("No Instruction")),
          )),
      Item(headerText: "Ingredients", expandedBody: Expanded(
            child: SizedBox(
                height: 400,
                child: widget.recipe.ingredients != null
                    ? ListView.builder(
                        itemCount: widget.recipe.ingredients.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                "${index + 1}. ${widget.recipe.ingredients[index]}",
                                style: const TextStyle(
                                    color: Colors.black, wordSpacing: 3),
                              ),
                            ), 
                          );
                        })
                    : const Text("No ingredients listed")),
          )),
      Item(
          headerText: "Video Guide",
          expandedBody: FutureBuilder(
              future: _initializeVideoPlayerFutrue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }))
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Detail Page")),
      body:
          Column(
        children: [
          RecipeCard(
            title: widget.recipe.name,
            cookTime: widget.recipe.totalTime,
            rating: widget.recipe.rating.toString(),
            thumbnailUrl: widget.recipe.images,
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView(
              children: data.map<Widget>((Item item) {
                return ExpansionTile(
                  title: Text(item.headerText),
                  children: [
                    ListTile(
                      title: item.expandedBody,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
     
    );
  }

  Future<void> webScrappe() async {
    String url =
        'https://www.yummly.com/private/recipe/Crispy-Herb-Roasted-Potatoes-9083689?layout=prep-steps.html';
    final dio = Dio();
    // Make a GET request to the URL and store the response
    final response = await dio.get(url);

    // Print the status code of the response
    print(response.statusCode);

    // Print the body of the response, which is the HTML content
    print(url);
    print(response.data);
  }

  Future showVideoDialog(String url) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Video Instructions"),
              content: FutureBuilder(
                  future: _initializeVideoPlayerFutrue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }));
        });
  }
}

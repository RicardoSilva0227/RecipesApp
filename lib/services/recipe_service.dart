import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe.dart';
import '../utils/request_manager.dart';
import '../config/config.dart';

class RecipeService {
  final String _baseUrl = 'https://api.spoonacular.com/recipes';

  Future<List<Recipe>> fetchRecipes(int page) async {
    final canRequest = await RequestManager.canMakeRequest();
    if (!canRequest) {
      throw Exception('Daily request limit reached. Try again tomorrow.');
    }

    final response = await http.get(Uri.parse(
      '$_baseUrl/complexSearch?number=10&offset=${(page - 1) * 10}&apiKey=${AppConfig.apiKey}',
    ));

    if (response.statusCode == 200) {
      await RequestManager.incrementRequestCount();
      final List data = json.decode(response.body)['results'];
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Map<String, dynamic>> fetchRecipeDetails(String recipeId) async {
    final canRequest = await RequestManager.canMakeRequest();
    if (!canRequest) {
      throw Exception('Daily request limit reached. Try again tomorrow.');
    }

    final response = await http.get(Uri.parse(
      '$_baseUrl/$recipeId/information?apiKey=${AppConfig.apiKey}',
    ));

    if (response.statusCode == 200) {
      await RequestManager.incrementRequestCount();
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}

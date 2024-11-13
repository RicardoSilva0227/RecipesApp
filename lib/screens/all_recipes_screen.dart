import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class AllRecipesScreen extends StatefulWidget {
  @override
  _AllRecipesScreenState createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  List<Recipe> _recipes = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  // Function to load recipes based on the current page
  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final recipes = await _recipeService.fetchRecipes(_currentPage);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load recipes: $e'),
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Build pagination controls
  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    _loadRecipes();
                  }
                : null,
            child: const Text('previous').tr(),
          ),
          Text('${'page'.tr()} $_currentPage'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage++;
              });
              _loadRecipes();
            },
            child: const Text('next').tr(),
          ),
        ],
      ),
    );
  }

  // Build the main UI of the recipes page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          leading: Image.network(
                                  recipe.image,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fitWidth,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 60, color: Colors.red);
                                  },
                                ),
                          title: Text(
                            recipe.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to recipe detail screen (to be implemented)
                          },
                        ),
                      );
                    },
                  ),
                ),
                _buildPaginationControls(),
              ],
            ),
    );
  }
}

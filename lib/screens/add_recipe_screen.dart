import 'package:flutter/material.dart';
import '../services/recipe_service.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipeService _recipeService = RecipeService();

  // Controllers for form inputs
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  // Additional properties
  List<String> _diets = [];
  List<String> _cuisines = [];
  List<String> _dishTypes = [];

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final newRecipe = await _recipeService.addRecipe(
        title: _titleController.text,
        image: _imageController.text,
        imageType: 'jpg', // Assuming imageType is known
        diets: _diets,
        servings: int.tryParse(_servingsController.text) ?? 1,
        prepTime: int.tryParse(_prepTimeController.text) ?? 0,
        cookTime: int.tryParse(_cookTimeController.text) ?? 0,
        readyInMinutes: (int.tryParse(_prepTimeController.text) ?? 0) +
            (int.tryParse(_cookTimeController.text) ?? 0),
        cuisines: _cuisines,
        dishTypes: _dishTypes,
        extendedIngredients: _parseIngredients(_ingredientsController.text),
        instructions: _instructionsController.text,
      );

      // Return to the previous screen or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe "${newRecipe.title}" added successfully!')),
      );

      Navigator.pop(context); // Close Add Recipe screen
    }
  }

  List<Map<String, dynamic>> _parseIngredients(String input) {
    // Split ingredients by line and create a list of maps
    return input.split('\n').map((line) {
      final parts = line.split(':'); // Example format: "Pasta: 200g"
      return {'name': parts[0].trim(), 'amount': parts.length > 1 ? parts[1].trim() : ''};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) => value!.isEmpty ? 'Image URL is required' : null,
              ),
              TextFormField(
                controller: _prepTimeController,
                decoration: InputDecoration(labelText: 'Prep Time (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _cookTimeController,
                decoration: InputDecoration(labelText: 'Cook Time (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _servingsController,
                decoration: InputDecoration(labelText: 'Servings'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients (one per line)'),
                maxLines: 5,
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: 'Instructions'),
                maxLines: 5,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

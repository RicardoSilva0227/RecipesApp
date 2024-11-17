import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../utils/helper.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  RecipeDetailScreen({required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  Map<String, dynamic>? _recipeDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipeDetails();
  }

  Future<void> _loadRecipeDetails() async {
    try {
      final details = await _recipeService.fetchRecipeDetails(widget.recipeId);
      setState(() {
        _recipeDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching recipe details: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipeDetails?['title'] ?? 'Recipe Details'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipeDetails != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Image with rounded corners
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _recipeDetails!['image'] ?? '',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Center(child: Icon(Icons.error, size: 100)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recipe Title
                      Text(
                        _recipeDetails?['title'] ?? 'Recipe Details',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Dietary Tags Section (Nullable)
                      if (_recipeDetails?['diets'] != null)
                        _buildDietaryTagsSection(),

                      const SizedBox(height: 16),

                      // Servings Section (Nullable)
                      if (_recipeDetails?['servings'] != null)
                        _buildServingsSection(),

                      const SizedBox(height: 16),

                      // Prep Time, Cook Time, Total Time Section (Nullable)
                      _buildTimeSection(),

                      const SizedBox(height: 16),

                      // Measurements Button
                      ElevatedButton(
                        onPressed: _showMeasurementDialog,
                        child: const Text("View Measurement Conversions"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                       ),

                      const SizedBox(height: 16),

                      // Ingredients Section (Nullable)
                      if (_recipeDetails?['extendedIngredients'] != null)
                        _buildIngredientsSection(),

                      const SizedBox(height: 16),

                      // Cuisines and Dish Types Section (Nullable)
                      _buildCuisinesDishTypesSection(),

                      const SizedBox(height: 16),

                      // Instructions Section (Nullable)
                      if (_recipeDetails?['instructions'] != null)
                        _buildInstructionsSection(),

                    ],
                  ),
                )
              : const Center(child: Text('Recipe details not found')),
    );
  }



  // Dietary Tags Section (Nullable)
  Widget _buildDietaryTagsSection() {
    if (_recipeDetails?['diets'] == null || (_recipeDetails!['diets'] as List).isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        const Text(
          'Dietary Tags: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ..._recipeDetails!['diets']
            .map<Widget>((diet) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    diet ?? 'N/A',
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ],
    );
  }


  // Servings Section (Nullable)
  Widget _buildServingsSection() {
    if (_recipeDetails?['servings'] == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        const Text(
          'Servings: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(_recipeDetails!['servings'].toString(),
            style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  // Prep Time, Cook Time, Total Time Section (Nullable)
  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_recipeDetails?['prepTime'] != null)
          _buildTimeRow('Prep Time', _recipeDetails!['prepTime']),
        if (_recipeDetails?['cookTime'] != null)
          _buildTimeRow('Cook Time', _recipeDetails!['cookTime']),
        if (_recipeDetails?['readyInMinutes'] != null)
          _buildTimeRow('Total Time', _recipeDetails!['readyInMinutes']),
      ],
    );
  }

  Widget _buildTimeRow(String label, int? time) {
    if (time == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            '$time minutes',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Ingredients Section (Nullable)
  Widget _buildIngredientsSection() {
    if (_recipeDetails?['extendedIngredients'] == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients:',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ..._recipeDetails!['extendedIngredients']
                    .map<Widget>((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 20, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(ingredient['original'])),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Cuisines and Dish Types Section (Nullable)
  Widget _buildCuisinesDishTypesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Cuisines and Dish Types:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 8),
      
      // Cuisines
      Text(
        'Cuisines: ${_recipeDetails?['cuisines']?.isNotEmpty == true ? _recipeDetails!['cuisines']?.join(', ') : 'N/A'}',
        style: const TextStyle(fontSize: 18),
      ),
      
      // Dish Types
      Text(
        'Dish Types: ${_recipeDetails?['dishTypes']?.isNotEmpty == true ? _recipeDetails!['dishTypes']?.join(', ') : 'N/A'}',
        style: const TextStyle(fontSize: 18),
      ),
    ],
  );
}

  // Instructions Section (Nullable)
  Widget _buildInstructionsSection() {
    if (_recipeDetails?['instructions'] == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions:',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        _recipeDetails!['instructions'] is String
            ? Text(removeHtmlTags(_recipeDetails!['instructions']))
            : Column(
                children: (_recipeDetails!['instructions'] as List<dynamic>)
                    .map<Widget>((instruction) {
                  final index = (_recipeDetails!['instructions'] as List)
                      .indexOf(instruction);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.orangeAccent,
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(removeHtmlTags(instruction))),
                      ],
                    ),
                  );
                }).toList(),
              ),
        const SizedBox(height: 16),
      ],
    );
  }

    Widget _buildMeasurementRow(String imperial, String metric) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(imperial, style: TextStyle(fontSize: 16)),
          const Spacer(),
          Text(metric, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }



void _showMeasurementDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Measurement Conversion"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMeasurementRow("1 teaspoon (tsp)", "5 ml"),
                _buildMeasurementRow("1 tablespoon (tbsp)", "15 ml"),
                _buildMeasurementRow("1 cup", "240 ml"),
                _buildMeasurementRow("1 ounce (oz)", "28.35 g"),
                _buildMeasurementRow("1 pound (lb)", "0.45 kg"),
                _buildMeasurementRow("1 fluid ounce (fl oz)", "30 ml"),
                _buildMeasurementRow("1 liter (L)", "1000 ml"),
                _buildMeasurementRow("1 kilogram (kg)", "1000 g"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }



}

import 'package:flutter/material.dart';
import 'package:recipes/utils/theme_manager.dart';  // Ensure path is correct

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // Variables to store the selected values
  String? _selectedLanguage = 'en';  // Default language is English
  String? _selectedMeasurement = 'kg';  // Default measurement is kg

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDarkModeToggle(),
            const SizedBox(height: 16),  // Space between sections
            _buildLanguageSelector(),
            const SizedBox(height: 16),  // Space between sections
            _buildMeasurementSelector(),
          ],
        ),
      ),
    );
  }

  // Dark Mode Toggle
  Widget _buildDarkModeToggle() {
    return Row(
      children: [
        const Text('Dark Mode'),
        const Spacer(),
        Switch(
          value: themeManager.themeNotifier.value == ThemeMode.dark,
          onChanged: (value) {
            themeManager.toggleTheme();
          },
        ),
      ],
    );
  }

  // Language Selector with retained selection
  Widget _buildLanguageSelector() {
    return Row(
      children: [
        const Text('Language'),
        const Spacer(),
        DropdownButton<String>(
          value: _selectedLanguage, // Set the value to the selected language
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'es', child: Text('Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('French')),
          ],
          onChanged: (String? value) {
            setState(() {
              _selectedLanguage = value;
            });
          },
          hint: const Text('Select Language'),
        ),
      ],
    );
  }

  // Measurement Selector with retained selection
  Widget _buildMeasurementSelector() {
    return Row(
      children: [
        const Text('Measurement Unit'),
        const Spacer(),
        DropdownButton<String>(
          value: _selectedMeasurement, // Set the value to the selected measurement unit
          items: const [
            DropdownMenuItem(value: 'kg', child: Text('Kilogram (kg)')),
            DropdownMenuItem(value: 'lb', child: Text('Pound (lb)')),
          ],
          onChanged: (String? value) {
            setState(() {
              _selectedMeasurement = value;
            });
          },
          hint: const Text('Select Measurement'),
        ),
      ],
    );
  }
}

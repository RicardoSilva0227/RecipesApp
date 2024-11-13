import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:recipes/utils/theme_manager.dart';  // Ensure the path is correct

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password visibility toggle
  bool _isPasswordHidden = true;

  // Default values for settings
  String _selectedLanguage = 'en'; // Default language
  String _selectedMeasurement = 'kg'; // Default measurement unit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account').tr(),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCardSection(
              context,
              'Personal Info'.tr(),
              [
                _buildTextField(_nameController, 'First Name'.tr()),
                const SizedBox(height: 16),
                _buildTextField(_surnameController, 'Surname'.tr()),
                const SizedBox(height: 16),
                _buildTextField(_displayNameController, 'Display Name'.tr()),
              ],
            ),
            const SizedBox(height: 16),
            _buildCardSection(
              context,
              'Change Email & Password'.tr(),
              [
                _buildTextField(_emailController, 'Email'.tr(), isEmail: true),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, 'New Password'.tr(), isPassword: true),
                const SizedBox(height: 16),
                _buildTextField(_confirmPasswordController, 'Confirm Password'.tr(), isPassword: true),
              ],
            ),
            const SizedBox(height: 16),
            _buildCardSection(
              context,
              'App Settings'.tr(),
              [
                _buildDarkModeToggle(),
                const SizedBox(height: 16),
                _buildLanguageSelector(),
                const SizedBox(height: 16),
                _buildMeasurementSelector(),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.teal,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.teal),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false, bool isEmail = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isPasswordHidden : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Row(
      children: [
        const Text('Dark Mode').tr(),
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

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        const Text('Language').tr(),
        const Spacer(),
        DropdownButton<String>(
          value: _selectedLanguage,
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'pt', child: Text('Português')),
          ],
          onChanged: (String? value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
          hint: const Text('Select Language').tr(),
        ),
      ],
    );
  }

  Widget _buildMeasurementSelector() {
    return Row(
      children: [
        const Text('Measurement Unit').tr(),
        const Spacer(),
        DropdownButton<String>(
          value: _selectedMeasurement,
          items: const [
            DropdownMenuItem(value: 'kg', child: Text('Kilogram (kg)')),
            DropdownMenuItem(value: 'lb', child: Text('Pound (lb)')),
          ],
          onChanged: (String? value) {
            setState(() {
              _selectedMeasurement = value!;
            });
          },
          hint: const Text('Select Measurement').tr(),
        ),
      ],
    );
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Changes saved!').tr()),
    );
  }
}

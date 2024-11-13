import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'account_screen.dart';
import 'all_recipes_screen.dart';
import 'my_recipes_screen.dart';
import 'liked_recipes_screen.dart';
import '../utils/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('pt')],
      path: 'assets/localization',
      fallbackLocale: Locale('en'),
      child: RecipeApp(),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Recipe App',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.orange,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.grey[850],
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey[500],
            ),
          ),
          themeMode: currentMode,
          home: HomeScreen(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AllRecipesScreen(),
    MyRecipesScreen(),
    LikedRecipesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'allRecipes'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'myRecipes'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'likedRecipes'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

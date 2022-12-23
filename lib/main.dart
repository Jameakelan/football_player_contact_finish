import 'package:flutter/material.dart';
import 'package:football_player_contact/helper/database_helper.dart';
import 'package:football_player_contact/screen/home_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper().initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(color: Colors.black)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

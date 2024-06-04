import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'models/user.dart'; // Make sure to import the User class here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  final userBox = await databaseService.initDatabase();
  runApp(MyApp(userBox: userBox));
}

class MyApp extends StatelessWidget {
  final Box<User> userBox;

  MyApp({required this.userBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wassim ben fraj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 33, 243, 128),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
      home: HomeScreen(userBox: userBox),
    );
  }
}

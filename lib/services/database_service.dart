import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class DatabaseService {
  static const String _userBoxName = 'users';

  Future<Box<User>> initDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    final box = await Hive.openBox<User>(_userBoxName);
    return box;
  }

  Box<User> getUserBox() {
    return Hive.box<User>(_userBoxName);
  }
}

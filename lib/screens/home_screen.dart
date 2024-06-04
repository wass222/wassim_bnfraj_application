import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import 'edit_user_screen.dart';

class HomeScreen extends StatefulWidget {
  final Box<User> userBox;

  HomeScreen({required this.userBox});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _translateController;
  late AnimationController _colorController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _translateAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _translateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(_fadeController);
    _translateAnimation = Tween<Offset>(begin: Offset(0, -0.2), end: Offset(0, 0.2)).animate(_translateController);
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(_colorController);

    _fadeController.repeat(reverse: true);
    _translateController.repeat(reverse: true);
    _colorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _translateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _translateController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _translateAnimation,
                    child: AnimatedBuilder(
                      animation: _colorController,
                      builder: (context, child) {
                        return Text(
                          'wassim ben fraj',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _colorAnimation.value,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.userBox.listenable(),
        builder: (context, Box<User> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No users added yet'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final user = box.getAt(index) as User;

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListTile(
                  title: Text(
                    user.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditUserScreen(user: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          user.delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

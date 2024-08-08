import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        backgroundColor: AppColors.menu1Color,
      ),
      body: Center(
        child: Text('Your books will be displayed here.'),
      ),
    );
  }
}
// TODO Implement this library.
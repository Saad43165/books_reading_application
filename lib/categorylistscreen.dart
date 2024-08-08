import 'dart:convert';
import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;
import 'category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final data = await DefaultAssetBundle.of(context).loadString("json/categories.json");
    final jsonResult = json.decode(data);
    setState(() {
      categories = jsonResult['categories'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Categories'),
        backgroundColor: AppColors.menu1Color,
      ),

      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(category: category['name'], categoryName: '',),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(category['image']),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),

                  ),
                  child: Text(
                    category['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

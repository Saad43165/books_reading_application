import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/bookdetailspage.dart';
import 'app_colors.dart' as AppColors;
import 'booksdetailspage.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({required this.categoryName, required category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    await DefaultAssetBundle.of(context)
        .loadString('json/books.json')
        .then((s) {
      final data = json.decode(s);
      setState(() {
        books = data['books'].where((book) => book['category'] == widget.categoryName).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: AppColors.menu1Color,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsPage(book: books[i]),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 7,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Add border radius
                    child: Image.asset(
                      books[i]['image'],
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          books[i]['title'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          books[i]['author'],
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Avenir',
                              color: AppColors.subTitleText),
                        ),
                        Text(
                          'Rating: ${books[i]['rating']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Avenir',
                              color: AppColors.starColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

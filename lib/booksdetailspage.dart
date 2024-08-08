import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
        backgroundColor: AppColors.menu1Color,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.background,
                image: DecorationImage(
                  image: AssetImage(book['image']),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Author: ${book['author']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.subTitleText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Redirect to the external website for reading the book
                          // For now, just showing a placeholder
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Read functionality will be added later')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.menu1Color,
                        ),
                        child: Text(
                          'Read',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Category: ${book['category']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: ${book['rating']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.starColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${book['description']}',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

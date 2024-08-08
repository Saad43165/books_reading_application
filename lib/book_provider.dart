import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  List<Map<String, dynamic>> _books = []; // List of all books
  List<Map<String, dynamic>> _filteredBooks = []; // Filtered books

  List<Map<String, dynamic>> get filteredBooks => _filteredBooks;

  void setBooks(List<Map<String, dynamic>> books) {
    _books = books;
    notifyListeners();
  }

  void filterBooksByCategory(String category) {
    _filteredBooks = _books.where((book) => book['category'] == category).toList();
    notifyListeners();
  }
}

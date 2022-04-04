import 'package:flutter/foundation.dart';

import 'data_models.dart';

// simulate different types of slow book loading
class BookService {
  static const int continueItemsBatchSize = 3;
  static const int newItemsBatchSize = 4;
  static const int searchItemsBatchSize = 2;

  static void init() {
    Library.initRandomLibrary(size: 40);
    if (kDebugMode) {
      print(Library.getNewBooks().map((e) => e.index));
      print(Library.getContinueBooks().map((e) => e.index));
    }
  }

  static Future<List<Object>> getContinueBooksBatch({int startNum = 0}) async {
    await Future.delayed(const Duration(seconds: 2), () {});

    final bool end = continueItemsBatchSize >= Library.getContinueBooks().length - startNum;
    return [
      Library.getContinueBooks()
          .sublist(startNum, end ? Library.getContinueBooks().length : continueItemsBatchSize + startNum),
      end
    ];
  }

  static Future<List<Object>> getNewItems({int startNum = 0}) async {
    await Future.delayed(const Duration(seconds: 2), () {});

    final bool end = newItemsBatchSize >= Library.getNewBooks().length - startNum;
    return [
      Library.getNewBooks().sublist(startNum, end ? Library.getNewBooks().length : newItemsBatchSize + startNum),
      end
    ];
  }

  static Future<List<Object>> getSearchItems(String data, {int startNum = 0}) async {
    await Future.delayed(const Duration(seconds: 2), () {});
    final List<Book> books = Library.getBooksBySearch(data);
    final bool end = searchItemsBatchSize >= books.length - startNum;
    return [books.sublist(startNum, end ? books.length : searchItemsBatchSize + startNum), end];
  }
}

class Library {
  static late List<Book> books;

  static void initRandomLibrary({int size = 5}) => books = List.generate(size, (index) => Book.random(index: index));

  static List<Book> getNewBooks() => books.where((book) => book.newItem).toList().cast<Book>();

  static List<Book> getContinueBooks() => books.where((book) => !book.newItem).toList().cast<Book>();

  static List<Book> getBooksBySearch(String data) => books
      .where(
        (book) =>
            book.title.toLowerCase().contains(data.toLowerCase()) ||
            book.subtitle.toLowerCase().contains(data.toLowerCase()) ||
            book.addedTime.year.toString() == data.toLowerCase(),
      )
      .toList()
      .cast<Book>();
}

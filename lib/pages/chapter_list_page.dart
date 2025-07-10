import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'verse_list_page.dart';

class ChapterListPage extends StatelessWidget {
  final BookModel book;

  const ChapterListPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: book.chapters,
        itemBuilder: (context, index) {
          final chapterNumber = index + 1;
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerseListPage(
                    bookRef: book.ref,
                    chapterNumber: chapterNumber,
                    bookName: book.name,
                  ),
                ),
              );
            },
            child: Text('$chapterNumber'),
          );
        },
      ),
    );
  }
}

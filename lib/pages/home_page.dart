import 'package:flutter/material.dart';
import 'book_list_page.dart';
import 'study_library_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Study App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookListPage()),
              ),
              child: const Text('Ler a Bíblia'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudyLibraryPage()),
              ),
              child: const Text('Meus Estudos Salvos'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/verse_model.dart';
import '../services/bible_service.dart';
import 'study_page.dart';

class VerseListPage extends StatelessWidget {
  final String bookRef;
  final int chapterNumber;
  final String bookName;

  const VerseListPage({
    super.key,
    required this.bookRef,
    required this.chapterNumber,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$bookName $chapterNumber'),
      ),
      body: FutureBuilder<List<VerseModel>>(
        future: BibleService().getVerses(bookRef, chapterNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final verses = snapshot.data;
          if (verses == null || verses.isEmpty) {
            return const Center(child: Text('Nenhum versículo encontrado.'));
          }
          return ListView.builder(
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              return ListTile(
                title: Text('${verse.ref.split(':').last}. ${verse.text}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyPage(
                        verseText: '${bookName} ${verse.ref}: ${verse.text}',
                        verseRef: verse.ref,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

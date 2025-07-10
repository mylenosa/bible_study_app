import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/study_model.dart';
import '../services/firestore_service.dart';
import 'webview_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_markdown/flutter_markdown.dart';

class StudyLibraryPage extends StatelessWidget {
  const StudyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Estudos')),
      body: StreamBuilder<List<StudyModel>>(
        stream: firestoreService.getStudies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum estudo salvo.'));
          }
          final studies = snapshot.data!;
          return ListView.builder(
            itemCount: studies.length,
            itemBuilder: (context, index) {
              final study = studies[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(study.verse),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(study.createdAt.toDate())),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudyDetailPage(study: study),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StudyDetailPage extends StatelessWidget {
  final StudyModel study;
  const StudyDetailPage({super.key, required this.study});

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (kIsWeb) {
      if (!await launchUrl(uri)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link.')),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WebViewPage(url: url)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(study.verse),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              FirestoreService().deleteStudy(study.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: study.studyText,
          selectable: true,
          onTapLink: (text, href, title) {
            if (href != null) {
              _openLink(context, href);
            }
          },
        ),
      ),
    );
  }
}

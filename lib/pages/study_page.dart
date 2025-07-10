import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/openai_service.dart';
import '../services/firestore_service.dart';
import 'webview_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StudyPage extends StatefulWidget {
  final String verseText;
  final String verseRef;

  const StudyPage({super.key, required this.verseText, required this.verseRef});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final OpenAIService _openAIService = OpenAIService();
  final FirestoreService _firestoreService = FirestoreService();
  Future<String>? _studyFuture;

  @override
  void initState() {
    super.initState();
    _generateStudy();
  }

  void _generateStudy() {
    setState(() {
      _studyFuture = _openAIService.generateStudy(widget.verseText);
    });
  }

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
      appBar: AppBar(title: Text(widget.verseRef)),
      body: FutureBuilder<String>(
        future: _studyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final studyText = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Markdown(
                      data: studyText,
                      selectable: true,
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          _openLink(context, href);
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _firestoreService.saveStudy(
                        verseText: widget.verseText,
                        studyText: studyText,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Estudo salvo!')),
                      );
                    },
                    child: const Text('Salvar Estudo'),
                  ),
                )
              ],
            );
          }
          return const Center(child: Text('Nenhum estudo gerado.'));
        },
      ),
    );
  }
}

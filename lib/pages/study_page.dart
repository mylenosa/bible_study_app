import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/openai_service.dart';
import '../services/firestore_service.dart';

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
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o link: $url')),
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Gerando estudo com IA...'),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Erro ao gerar estudo: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.hasData) {
            final studyText = snapshot.data!;
            return SingleChildScrollView(
              // The Padding widget remains to give some space on the sides.
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                // The margin is removed from the Card to let it fill the space given by Padding.
                // margin: const EdgeInsets.all(8.0), 
                child: Column(
                  // This is the main fix. It tells the Column to stretch its children
                  // to fill the available horizontal space.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: MarkdownBody(
                        data: studyText,
                        selectable: true,
                        onTapLink: (text, href, title) {
                          if (href != null) {
                            _openLink(context, href);
                          }
                        },
                      ),
                    ),
                    // Add some padding to the button so it doesn't touch the card edges.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar Estudo'),
                        onPressed: () {
                          _firestoreService.saveStudy(
                            verseText: widget.verseText,
                            studyText: studyText,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Estudo salvo com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Nenhum estudo foi gerado.'));
        },
      ),
    );
  }
}

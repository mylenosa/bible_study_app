import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'book_list_page.dart';
import 'study_library_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Função para executar o logout
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título da aplicação atualizado aqui
        title: const Text('Diário de Estudos Bíblicos + IA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
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
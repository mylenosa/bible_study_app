import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/pages/book_list_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/study_library_page.dart';
import 'pages/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estudos Bíblicos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      // A página de autenticação decide qual a primeira página a ser mostrada.
      home: const AuthPage(),
      // Definição das rotas nomeadas para uma navegação mais limpa.
      routes: {
        '/home': (context) => const HomePage(),
        '/book-list': (context) => const BookListPage(),
        '/study-library': (context) => const StudyLibraryPage(),
      },
    );
  }
}
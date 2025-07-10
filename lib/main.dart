import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  // Garante que o Flutter está inicializado antes de chamar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega as variáveis de ambiente (como a sua chave da OpenAI)
  await dotenv.load(fileName: ".env");
  // Inicia a ligação com o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inicia a aplicação
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
      ),
      // A linha mais importante:
      // A AuthPage é a página inicial e ela irá gerir o fluxo de autenticação.
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
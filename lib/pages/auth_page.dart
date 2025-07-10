import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Enquanto o Firebase está a verificar o estado (a conectar)...
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ...mostre um ecrã de carregamento. Isto quebra o loop.
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Se o Firebase já respondeu e tem um utilizador logado...
          if (snapshot.hasData) {
            return const HomePage();
          } 
          
          // 3. Se o Firebase respondeu e não tem um utilizador logado...
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
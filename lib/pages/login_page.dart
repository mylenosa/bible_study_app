import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      }
      // A navegação será tratada pelo AuthPage, não é necessário Navigator.push aqui.
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocorreu um erro de autenticação.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum utilizador encontrado com este e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'A palavra-passe está incorreta.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este e-mail já está a ser utilizado.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'A palavra-passe é demasiado fraca.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('Ocorreu um erro inesperado. Por favor, tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _emailController, labelText: 'Email'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _passwordController,
                labelText: 'Senha',
                obscureText: true),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              CustomButton(
                  onPressed: _submit, text: _isLogin ? 'Login' : 'Criar Conta'),
            if (!_isLoading)
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin
                    ? 'Não tem uma conta? Crie uma'
                    : 'Já tem uma conta? Faça login'),
              )
          ],
        ),
      ),
    );
  }
}
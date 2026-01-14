import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color yellow = Color(0xFFF1DB4B);
  static const Color dark = Color(0xFF2D2D2D);

  void _navigate(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, animation, _, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // direita → esquerda
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,

      appBar: AppBar(
        backgroundColor: dark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'byKeria',
          style: TextStyle(
            color: yellow,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão Login
              SizedBox(
                width: 250,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    _navigate(context, const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Fazer Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão Cadastro
              SizedBox(
                width: 250,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    _navigate(context, const RegisterScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bike_app/screens/home_screen.dart';
import 'package:bike_app/screens/profile_screen.dart';
import 'package:bike_app/screens/welcome_screen.dart';
import 'package:bike_app/services/user_session.dart';
import 'package:bike_app/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PixScreen extends StatelessWidget {
  const PixScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    UserSession.instance.clear();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowTrue,

      // 🔹 MENU SANDUÍCHE
      drawer: Drawer(
        backgroundColor: AppColors.dark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'byKeria',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Divider(color: AppColors.gray),

              // 🔹 SWITCH CLARO/ESCURO
              ListTile(
                leading: Icon(
                  AppColors.isDark ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.yellow,
                ),
                title: Text(
                  AppColors.isDark ? 'Modo Escuro' : 'Modo Claro',
                  style: TextStyle(color: AppColors.yellow),
                ),
                trailing: Switch(
                  value: AppColors.isDark,
                  onChanged: (val) {
                    // alterna o tema
                    AppColors.isDark = val;
                    // força rebuild da tela para aplicar cores
                    (context as Element).reassemble(); // simples e rápido
                  },
                  activeColor: AppColors.yellow,
                ),
              ),

              Divider(color: AppColors.gray),

              ListTile(
                leading: Icon(Icons.logout, color: AppColors.yellow),
                title: Text('Sair', style: TextStyle(color: AppColors.yellow)),
                onTap: () async {
                  Navigator.pop(context); // fecha o drawer
                  await _logout(context);
                },
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'byKeria',
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.yellow),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: AppColors.yellow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      // 🟡 CONTEÚDO
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // TÍTULO
                const Text(
                  'Sua chave PIX',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                    color: Color(0xFF2D2D2D),
                  ),
                ),

                const Spacer(),

                const SizedBox(height: 24),

                // 🗺️ CARD DO MAPA
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/qrcode.png',
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // TEXTO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Copiar chave para área de transferência',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.darkTrue),
                  ),
                ),

                const Spacer(),

                // BOTÃO PIX
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text(
                      'Voltar à tela inicial',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bike_app/screens/welcome_screen.dart';
import 'package:bike_app/services/auth_service.dart';
import 'package:bike_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_session.dart';

import '../data/mock_bike_posts.dart';
import '../models/bike_post.dart';
import 'post_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await _authService.getUserData();
    if (data != null) {
      UserSession.instance.setUser(data);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    UserSession.instance.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,

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

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Boas-vindas, ${UserSession.instance.name}!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Onde vamos pedalar hoje?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: AppColors.white),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: AppColors.dark),

                // Lista de postos
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: mockBikePosts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final BikePost post = mockBikePosts[index];
                      return BikePostCard(post: post);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class BikePostCard extends StatelessWidget {
  final BikePost post;

  const BikePostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              post.imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${post.availableBikes} bicicletas disponíveis',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/mock_bike_posts.dart';
import '../models/bike_post.dart';
import 'post_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color yellow = Color(0xFFF1DB4B);
  static const Color dark = Color(0xFF2D2D2D);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // NÃO navega manualmente
    // AuthGate cuida disso
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,

      // 🔹 MENU SANDUÍCHE
      drawer: Drawer(
        backgroundColor: dark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'byKeria',
                  style: TextStyle(
                    color: yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(color: Colors.white24),

              ListTile(
                leading: const Icon(Icons.logout, color: yellow),
                title: const Text('Sair', style: TextStyle(color: yellow)),
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
        backgroundColor: dark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'byKeria',
          style: TextStyle(color: yellow, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: yellow),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: yellow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Boas-vindas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Bem-vindo, Matheus',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Onde vamos pedalar hoje?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: dark),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: dark),

          // Lista de postos
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: mockBikePosts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${post.availableBikes} bicicletas disponíveis',
                      style: const TextStyle(color: Colors.white70),
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

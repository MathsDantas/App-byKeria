import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,

      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'byKeria',
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.yellow),
          onPressed: () {},
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Foto de perfil
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),

            const SizedBox(height: 16),

            // Nome
            const Text(
              'Matheus Dantas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Botão editar perfil
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.dark,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppColors.dark),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Editar perfil',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Estatísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ProfileStat(value: '10', label: 'Bikes alugadas'),
                _ProfileStat(value: '98', label: 'Quilômetros rodados'),
              ],
            ),

            const SizedBox(height: 32),

            // Histórico
            Column(
              children: const [
                Icon(Icons.access_time, size: 32, color: AppColors.purple),
                SizedBox(height: 8),
                Text(
                  'Ver histórico de corridas',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Divider(),

            // Opções
            ListTile(
              title: Text(
                'Ver informações pessoais',
                style: TextStyle(color: AppColors.purple),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Ver informações de pagamento',
                style: TextStyle(color: AppColors.purple),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para estatísticas
class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.purple),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/models/bike_post.dart';
import '../theme/app_colors.dart';

class PostDetailScreen extends StatelessWidget {
  final BikePost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.dark,

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
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.yellow),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TÍTULO + ENDEREÇO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.address,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // MAPA
          SizedBox(
            height: screenHeight * 0.65,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: post.location,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('posto'),
                    position: post.location,
                  ),
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),

          // RODAPÉ
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.openingHours,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purple,
                      ),
                    ),
                    Text(
                      post.openingDays,
                      style: const TextStyle(color: AppColors.purple),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${post.availableBikes} bicicletas disponíveis',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.dark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: AppColors.dark),
                    ),
                  ),
                  onPressed: () {
                    // futura ação QR Code
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text(
                    'Pegue sua bike!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

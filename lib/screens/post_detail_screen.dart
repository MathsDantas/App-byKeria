import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/models/bike_post.dart';
import '../theme/app_colors.dart';

import 'scan_qr_page.dart';

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
        title: Text(
          'byKeria',
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.yellow),
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
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(post.address, style: TextStyle(color: AppColors.white)),
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
            padding: const EdgeInsets.all(20),
            color: AppColors.yellowTrue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.openingHours,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purple,
                      ),
                    ),
                    Text(
                      post.openingDays,
                      style: TextStyle(color: AppColors.purple),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${post.availableBikes} bicicletas disponíveis',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.purple,
                      ),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowTrue,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanQrPage()),
                    );
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

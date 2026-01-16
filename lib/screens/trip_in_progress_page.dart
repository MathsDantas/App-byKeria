import 'dart:async';
import 'package:bike_app/screens/devolucao.dart';
import 'package:bike_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TripInProgressPage extends StatefulWidget {
  const TripInProgressPage({super.key});

  @override
  State<TripInProgressPage> createState() => _TripInProgressPageState();
}

class _TripInProgressPageState extends State<TripInProgressPage> {
  // ignore: unused_field
  GoogleMapController? _mapController;
  Position? _currentPosition;

  late Timer _timer;
  Duration remainingTime = const Duration(hours: 1, minutes: 30);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTimer();
  }

  // GPS
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {});
  }

  // Cronômetro
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // MAPA
          Expanded(
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 16,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
          ),

          // PAINEL INFERIOR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppColors.yellowTrue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Em viagem...',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    _timeBox(twoDigits(remainingTime.inHours), 'horas'),
                    const SizedBox(width: 12),
                    _timeBox(
                      twoDigits(remainingTime.inMinutes.remainder(60)),
                      'minutos',
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40), // 👈 sobe o botão
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Devolucao()),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Encerrar viagem'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black, // fundo do box
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.yellowTrue, // número
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.yellowTrue, // label agora também amarelo
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

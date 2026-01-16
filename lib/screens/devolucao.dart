import 'dart:convert';
import 'package:bike_app/screens/viagem_encerrada.dart';
import 'package:bike_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Devolucao extends StatefulWidget {
  const Devolucao({super.key});

  @override
  State<Devolucao> createState() => _DevolucaoState();
}

class _DevolucaoState extends State<Devolucao> {
  Position? _currentPosition;
  GoogleMapController? _mapController;

  final Set<Polyline> _polylines = {};

  /// 📍 Posto fixo
  final LatLng postoDevolucao = const LatLng(
    -4.977121765676975,
    -39.040232678045456,
  );

  /// 🔑 SUA API KEY
  final String googleApiKey = 'AIzaSyDL3dZoFqRZ_1z2y1YMsSOMl9yxdUBpg7Y';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 📡 GPS
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

    await _getRoutePolyline();

    setState(() {});
  }

  // 🧭 BUSCA ROTA
  Future<void> _getRoutePolyline() async {
    final origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final destination =
        '${postoDevolucao.latitude},${postoDevolucao.longitude}';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$origin'
        '&destination=$destination'
        '&mode=walking'
        '&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    final points = data['routes'][0]['overview_polyline']['points'];

    final List<LatLng> polylineCoords = _decodePolyline(points);

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('rota'),
        color: Colors.blue,
        width: 5,
        points: polylineCoords,
      ),
    );
  }

  // 🔄 Decode Polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  // 📐 Enquadra tudo
  void _fitBounds() {
    if (_mapController == null || _currentPosition == null) return;

    final user = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    final bounds = LatLngBounds(
      southwest: LatLng(
        user.latitude < postoDevolucao.latitude
            ? user.latitude
            : postoDevolucao.latitude,
        user.longitude < postoDevolucao.longitude
            ? user.longitude
            : postoDevolucao.longitude,
      ),
      northeast: LatLng(
        user.latitude > postoDevolucao.latitude
            ? user.latitude
            : postoDevolucao.latitude,
        user.longitude > postoDevolucao.longitude
            ? user.longitude
            : postoDevolucao.longitude,
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🗺 MAPA
          Expanded(
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: postoDevolucao,
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    markers: {
                      Marker(
                        markerId: const MarkerId('posto'),
                        position: postoDevolucao,
                        infoWindow: const InfoWindow(
                          title: 'Posto de devolução',
                        ),
                      ),
                    },
                    polylines: _polylines,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _fitBounds();
                    },
                  ),
          ),

          // 🟡 PAINEL
          SafeArea(
            top: false, // não mexe no topo
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                28,
              ), // 👈 sobe tudo
              color: AppColors.yellowTrue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min, // 👈 evita ocupar mais espaço que o necessário
                children: [
                  const Text(
                    'Devolva sua bike ao posto...',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViagemEncerradaPage(),
                          ),
                        );
                      },
                      child: const Icon(Icons.check),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

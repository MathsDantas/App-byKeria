import 'package:google_maps_flutter/google_maps_flutter.dart';

class BikePost {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final int availableBikes;
  final String imagePath;
  final String openingHours;
  final String openingDays;

  BikePost({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.availableBikes,
    required this.imagePath,
    required this.openingHours,
    required this.openingDays,
  });
}

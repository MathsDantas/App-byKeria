import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/bike_post.dart';

final List<BikePost> mockBikePosts = [
  BikePost(
    id: '1',
    name: 'Posto Santa Clotilde',
    address: '2434, R. José Freitas Queiroz, 2130',
    location: const LatLng(-22.4015, -47.5626),
    availableBikes: 5,
    imagePath: 'assets/images/posto2.png',
    openingHours: '6h às 20h',
    openingDays: 'Segunda à Sábado',
  ),
  BikePost(
    id: '2',
    name: 'Posto Quiosque da Tia',
    address: 'Av. Central, 1020',
    location: const LatLng(-22.4042, -47.5601),
    availableBikes: 2,
    imagePath: 'assets/images/posto3.png',
    openingHours: '7h às 22h',
    openingDays: 'Todos os dias',
  ),
  BikePost(
    id: '3',
    name: 'Posto José de Barros',
    address: 'Praça José de Barros, 88',
    location: const LatLng(-22.3987, -47.5653),
    availableBikes: 8,
    imagePath: 'assets/images/posto1.png',
    openingHours: '6h às 18h',
    openingDays: 'Segunda à Sexta',
  ),
];

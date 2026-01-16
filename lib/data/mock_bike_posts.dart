import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/bike_post.dart';

final List<BikePost> mockBikePosts = [
  BikePost(
    id: '1',
    name: 'Posto Santa Clotilde',
    address: '2434, R. José Freitas Queiroz, 2130',
    location: const LatLng(-4.977130673682634, -39.04025878906841),
    availableBikes: 5,
    imagePath: 'assets/images/posto2.png',
    openingHours: '6h às 20h',
    openingDays: 'Segunda à Sábado',
  ),
  BikePost(
    id: '2',
    name: 'Posto Quiosque da Tia',
    address: 'Av. Central, 1020',
    location: const LatLng(-4.978537832378513, -39.05685787915902),
    availableBikes: 2,
    imagePath: 'assets/images/posto3.png',
    openingHours: '7h às 22h',
    openingDays: 'Todos os dias',
  ),
  BikePost(
    id: '3',
    name: 'Posto José de Barros',
    address: 'Praça José de Barros, 88',
    location: const LatLng(-4.969864108140697, -39.01567785261365),
    availableBikes: 8,
    imagePath: 'assets/images/posto1.png',
    openingHours: '6h às 18h',
    openingDays: 'Segunda à Sexta',
  ),
];

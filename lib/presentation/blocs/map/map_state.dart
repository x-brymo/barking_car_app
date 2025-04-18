// presentation/blocs/map/map_state.dart
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/models/parking_spot_model.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final LatLng currentLocation;
  final List<ParkingSpotModel> parkingSpots;
  final ParkingSpotModel? selectedParkingSpot;
  
  MapLoaded({
    required this.currentLocation,
    required this.parkingSpots,
    this.selectedParkingSpot,
  });
}

class MapError extends MapState {
  final String message;
  
  MapError({
    required this.message,
  });
}
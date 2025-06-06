// presentation/blocs/map/map_event.dart
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:latlong2/latlong.dart';

import '../../../data/models/parking_spot_model.dart';

abstract class MapEvent {}

class LoadMap extends MapEvent {}

class SelectParkingSpot extends MapEvent {
  final ParkingSpotModel parkingSpot;
  
  SelectParkingSpot({
    required this.parkingSpot,
  });
}

class RefreshParkingSpots extends MapEvent {}
class FetchParkingSpots extends MapEvent {}
class GetCurrentLocation extends MapEvent {
  GetCurrentLocation();
}
class CurrentLocationObtained extends MapEvent {
  final LatLng currentLocation;
  
  CurrentLocationObtained({
    required this.currentLocation,
  });
}
class AddParkingSpot extends MapEvent {
  final ParkingSpotModel parkingSpot;
  
  AddParkingSpot({
    required this.parkingSpot,
  });
}
class UpdateParkingSpot extends MapEvent {
  final ParkingSpotModel parkingSpot;
  
  UpdateParkingSpot({
    required this.parkingSpot,
  });
}
class DeleteParkingSpot extends MapEvent {
  final String parkingSpotId;
  
  DeleteParkingSpot({
    required this.parkingSpotId,
  });
}
class ShowAddParkingSpotDialog extends MapEvent {
  final Function(ParkingSpotModel) onAdd;
  
  ShowAddParkingSpotDialog({
    required this.onAdd,
  });
}
class ShowUpdateParkingSpotDialog extends MapEvent {
  final ParkingSpotModel parkingSpot;
  final Function(ParkingSpotModel) onUpdate;
  
  ShowUpdateParkingSpotDialog({
    required this.parkingSpot,
    required this.onUpdate,
  });
}

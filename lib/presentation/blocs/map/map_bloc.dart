// presentation/blocs/map/map_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/repositories/parking_repository.dart';
import '../../../data/services/location_service.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ParkingRepository _parkingRepository;
  final LocationService _locationService;
  
  MapBloc(this._parkingRepository, this._locationService) : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<SelectParkingSpot>(_onSelectParkingSpot);
    on<RefreshParkingSpots>(_onRefreshParkingSpots);
  }
  
  Future<void> _onLoadMap(
    LoadMap event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    try {
      // Get current location
      final position = await _locationService.getCurrentLocation();
      final currentLocation = LatLng(position.latitude, position.longitude);
      
      // Get parking spots
      final parkingSpots = await _parkingRepository.getParkingSpots();
      
      emit(MapLoaded(
        currentLocation: currentLocation,
        parkingSpots: parkingSpots,
        selectedParkingSpot: null,
      ));
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }
  
  Future<void> _onSelectParkingSpot(
    SelectParkingSpot event,
    Emitter<MapState> emit,
  ) async {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(MapLoaded(
        currentLocation: currentState.currentLocation,
        parkingSpots: currentState.parkingSpots,
        selectedParkingSpot: event.parkingSpot,
      ));
    }
  }
  
  Future<void> _onRefreshParkingSpots(
    RefreshParkingSpots event,
    Emitter<MapState> emit,
  ) async {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(MapLoading());
      try {
        final parkingSpots = await _parkingRepository.getParkingSpots();
        emit(MapLoaded(
          currentLocation: currentState.currentLocation,
          parkingSpots: parkingSpots,
          selectedParkingSpot: null,
        ));
      } catch (e) {
        emit(MapError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
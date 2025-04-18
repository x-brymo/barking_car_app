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
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<FetchParkingSpots>(_onFetchParkingSpots);
    on<AddParkingSpot>(_onAddParkingSpot);
    on<CurrentLocationObtained>(_onCurrentLocationObtained);
    //on<ShowAddParkingSpotDialog>(_onShowAddParkingSpotDialog);

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
  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    try {
      final position = await _locationService.getCurrentLocation();
      final currentLocation = LatLng(position.latitude, position.longitude);
      emit(MapLoaded(
        currentLocation: currentLocation,
        parkingSpots: (state as MapLoaded).parkingSpots,
        selectedParkingSpot: (state as MapLoaded).selectedParkingSpot,
      ));
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }
  Future<void> _onFetchParkingSpots(
    FetchParkingSpots event,
    Emitter<MapState> emit,
  ) async {
    try {
      final parkingSpots = await _parkingRepository.getParkingSpots();
      emit(MapLoaded(
        currentLocation: (state as MapLoaded).currentLocation,
        parkingSpots: parkingSpots,
        selectedParkingSpot: (state as MapLoaded).selectedParkingSpot,
      ));
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }
  Future<void> _onAddParkingSpot(
    AddParkingSpot event,
    Emitter<MapState> emit,
  ) async {
    try {
      final parkingSpot = await _parkingRepository.createParkingSpot(event.parkingSpot.toJson());
      if (parkingSpot != null) {
        final currentState = state;
        if (currentState is MapLoaded) {
          emit(MapLoaded(
            currentLocation: currentState.currentLocation,
            parkingSpots: [...currentState.parkingSpots, parkingSpot],
            selectedParkingSpot: null,
          ));
        }
      } else {
        emit(MapError(message: 'Failed to add parking spot'));
      }
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }
   Future<void> _onCurrentLocationObtained(
    CurrentLocationObtained event,
    Emitter<MapState> emit,
  ) async {
    try {
      final position = await _locationService.getCurrentLocation();
      final currentLocation = LatLng(position.latitude, position.longitude);
      emit(MapLoaded(
        currentLocation: currentLocation,
        parkingSpots: (state as MapLoaded).parkingSpots,
        selectedParkingSpot: (state as MapLoaded).selectedParkingSpot,
      ));
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }
  // Future<void> _onShowAddParkingSpotDialog(
  //   ShowAddParkingSpotDialog event,
  //   Emitter<MapState> emit,
  // ) async {
  //   try {
  //     // Show dialog to add parking spot
  //     final newParkingSpot = await event.onAdd(event.(){});
  //     if (newParkingSpot != null) {
  //       final currentState = state;
  //       if (currentState is MapLoaded) {
  //         emit(MapLoaded(
  //           currentLocation: currentState.currentLocation,
  //           parkingSpots: [...currentState.parkingSpots, newParkingSpot],
  //           selectedParkingSpot: null,
  //         ));
  //       }
  //     }
  //   } catch (e) {
  //     emit(MapError(message: e.toString()));
  //   }
  // }
}
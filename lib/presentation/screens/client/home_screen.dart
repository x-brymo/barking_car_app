// CLIENT SCREENS
// presentation/screens/client/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../data/models/parking_spot_model.dart';
import '../../../presentation/blocs/map/map_bloc.dart';
import '../../../presentation/blocs/map/map_event.dart';
import '../../../presentation/blocs/map/map_state.dart';
import '../../../presentation/widgets/parking_marker.dart';
import '../../../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  ParkingSpotModel? _selectedParkingSpot;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    // Load parking spots
    context.read<MapBloc>().add((LoadMap()));
  }
  
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Get current location
    context.read<MapBloc>().add(GetCurrentLocation());
  }
  
  void _createMarkers(List<ParkingSpotModel> parkingSpots) {
    _markers = parkingSpots.map((spot) {
      return Marker(
        markerId: MarkerId(spot.id),
        position: spot.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () {
          setState(() {
            _selectedParkingSpot = spot;
          });
        },
        infoWindow: InfoWindow(
          title: spot.name,
          snippet: '\$${spot.pricePerHour.toStringAsFixed(2)} / hr',
        ),
      );
    }).toSet();
    
    setState(() {});
  }
  
  void _moveToCurrentLocation(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: AppConstants.mapDefaultZoom,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barking Car'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).pushNamed(Routes.history),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).pushNamed(Routes.profile),
          ),
        ],
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            setState(() {
              _isLoading = false;
            });
            _createMarkers(state.parkingSpots);
          }
          if (state is MapLoaded) {
                final currentState = state as MapLoaded;
                final lat = currentState.currentLocation.latitude;
              }
          if (state is CurrentLocationObtained) {
             final currentState = state as MapLoaded;
            final l = currentState.currentLocation;
            _moveToCurrentLocation(l);
          }
          
          if (state is MapError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
                  zoom: AppConstants.mapDefaultZoom,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                compassEnabled: true,
              ),
              
              // Loading indicator
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
                
              // Bottom sheet for selected parking spot
              if (_selectedParkingSpot != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title and close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedParkingSpot!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedParkingSpot = null;
                                });
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Address
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                _selectedParkingSpot!.address,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${_selectedParkingSpot!.pricePerHour.toStringAsFixed(2)} / hour',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Book button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to booking screen with selected parking spot
                              Navigator.of(context).pushNamed(
                                Routes.booking,
                                arguments: _selectedParkingSpot,
                              );
                            },
                            child: const Text('Book Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
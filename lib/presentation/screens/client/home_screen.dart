// CLIENT SCREENS
// presentation/screens/client/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../data/models/parking_spot_model.dart';
import '../../../presentation/blocs/map/map_bloc.dart';
import '../../../presentation/blocs/map/map_event.dart';
import '../../../presentation/blocs/map/map_state.dart';
import '../../../presentation/widgets/parking_marker.dart';
import '../../../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MapController _mapController;
  List<Marker> _markers = [];
  ParkingSpotModel? _selectedParkingSpot;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    context.read<MapBloc>().add(LoadMap());
    context.read<MapBloc>().add(GetCurrentLocation());
  }

  void _createMarkers(List<ParkingSpotModel> parkingSpots) {
    _markers = parkingSpots.map((spot) {
      return Marker(
        width: 50,
        height: 50,
        point: LatLng(spot.latitude, spot.longitude),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedParkingSpot = spot;
            });
          },
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    }).toList();
    setState(() {});
  }

  void _moveToCurrentLocation(LatLng position) {
    _mapController.move(position, AppConstants.mapDefaultZoom);
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
            _isLoading = false;
            _createMarkers(state.parkingSpots);
            _moveToCurrentLocation(state.currentLocation);
          } else if (state is MapError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(30.0444, 31.2357), // Default: Cairo
                  //initialZoom: AppConstants.mapDefaultZoom,
                  //zoom: AppConstants.mapDefaultZoom,
                  maxZoom: 18,
                  minZoom: 10,
                  keepAlive: true,
                  onTap: (_, __) => setState(() => _selectedParkingSpot = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.barking_car_app',
                  ),
                  MarkerLayer(markers: _markers),
                ],
              ),

              if (_isLoading)
                const Center(child: CircularProgressIndicator()),

              if (_selectedParkingSpot != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedParkingSpot!.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => setState(() => _selectedParkingSpot = null),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                _selectedParkingSpot!.address,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${_selectedParkingSpot!.pricePerHour.toStringAsFixed(2)} / hour',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
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

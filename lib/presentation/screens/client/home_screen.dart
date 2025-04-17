import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../presentation/blocs/map/map_bloc.dart';
import '../../../presentation/blocs/map/map_event.dart';
import '../../../presentation/blocs/map/map_state.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(FetchParkingSpots());
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: state.currentLocation,
                    zoom: 15,
                  ),
                  markers: state.parkingSpots.map((spot) {
                    return Marker(
                      markerId: MarkerId(spot.id),
                      position: LatLng(spot.latitude, spot.longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ),
                      infoWindow: InfoWindow(title: spot.name),
                    );
                  }).toSet(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: CustomButton(
                    text: 'Book Nearest Spot',
                    onPressed: () {
                      // ممكن نعمل حجز مباشر لأقرب نقطة مثلاً
                      // أو نفتح شاشة جديدة لاختيار نقطة الحجز
                      
                      Navigator.pushNamed(context, '/booking');
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Failed to load map'));
        },
      ),
    );
  }
}

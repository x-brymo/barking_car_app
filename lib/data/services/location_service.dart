// data/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../../core/utils/location_utils.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    return await LocationUtils.getCurrentPosition();
  }
  
  Future<String> getAddressFromCoordinates(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return 'Unknown location';
    } catch (e) {
      return 'Address not available';
    }
  }
  
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      return [];
    }
  }

  
  Future<LatLng> getLatLngFromAddress(String address) async {
    List<Location> locations = await getCoordinatesFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations[0].latitude, locations[0].longitude);
    }
    throw Exception('Could not find coordinates for the address: $address');
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    return await getAddressFromCoordinates(latLng);
  }                                           
}
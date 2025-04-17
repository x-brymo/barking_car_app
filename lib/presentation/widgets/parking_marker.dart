// presentation/widgets/parking_marker.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets_constants.dart';
import '../../data/models/parking_spot_model.dart';

class ParkingMarker extends StatelessWidget {
  final ParkingSpotModel parkingSpot;
  final bool isSelected;
  
  const ParkingMarker({
    super.key,
    required this.parkingSpot,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsConstants.carMarker,
          height: 50,
          width: 50,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.blue : Colors.green,
            BlendMode.srcIn,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '\$${parkingSpot.pricePerHour.toStringAsFixed(2)}/hr',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
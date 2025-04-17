// presentation/widgets/booking_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final Map<String, dynamic>? parkingSpotData;
  final VoidCallback? onTap;
  
  const BookingCard({
    super.key,
    required this.booking,
    this.parkingSpotData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');
    final parkingName = parkingSpotData?['name'] ?? 'Unknown Parking';
    final parkingAddress = parkingSpotData?['address'] ?? 'Address not available';
    
    Color statusColor;
    switch (booking.status) {
      case 'active':
        statusColor = AppTheme.successColor;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'completed':
        statusColor = Colors.blue;
        break;
      case 'cancelled':
        statusColor = AppTheme.errorColor;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parkingName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                parkingAddress,
                style: const TextStyle(
                  color: AppTheme.lightTextColor,
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.lightTextColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'From: ${dateFormat.format(booking.startTime)}',
                    style: const TextStyle(
                      color: AppTheme.lightTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.lightTextColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'To: ${dateFormat.format(booking.endTime)}',
                    style: const TextStyle(
                      color: AppTheme.lightTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\$${booking.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
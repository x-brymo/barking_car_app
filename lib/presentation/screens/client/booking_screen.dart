import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/parking_spot_model.dart';
import '../../../presentation/blocs/booking/booking_bloc.dart';
import '../../../presentation/blocs/booking/booking_event.dart';
import '../../../presentation/blocs/booking/booking_state.dart';
import '../../widgets/custom_button.dart';

class BookingScreen extends StatelessWidget {
  final ParkingSpotModel spot;

  const BookingScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    void confirmBooking() {
      context.read<BookingBloc>().add(
            CreateBooking(bookingData: spot.toJson()),
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingsLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Booking successful!")),
            );
            Navigator.pop(context);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Parking Spot:", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(spot.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text("Location: ${spot.address}"),
              const SizedBox(height: 8),
              Text("Price per hour: \$${spot.pricePerHour.toStringAsFixed(2)}"),
              const Spacer(),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return state is BookingLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: 'Confirm Booking',
                          onPressed: confirmBooking,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

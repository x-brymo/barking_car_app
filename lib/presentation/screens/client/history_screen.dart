import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/booking/booking_bloc.dart';
import '../../../presentation/blocs/booking/booking_state.dart';
import '../../widgets/booking_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking History')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingsLoaded && state.bookings.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return BookingCard(booking: booking);
              },
            );
          }

          if (state is BookingsLoaded && state.bookings.isEmpty) {
            return const Center(child: Text("No previous bookings found."));
          }

          return const Center(child: Text("Something went wrong."));
        },
      ),
    );
  }
}

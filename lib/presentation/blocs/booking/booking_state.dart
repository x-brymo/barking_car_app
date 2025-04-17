// presentation/blocs/booking/booking_state.dart
import '../../../data/models/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<BookingModel> bookings;
  
  BookingsLoaded({
    required this.bookings,
  });
}

class BookingCreated extends BookingState {
  final BookingModel booking;
  
  BookingCreated({
    required this.booking,
  });
}

class DashboardStatsLoaded extends BookingState {
  final Map<String, dynamic> stats;
  
  DashboardStatsLoaded({
    required this.stats,
  });
}

class BookingError extends BookingState {
  final String message;
  
  BookingError({
    required this.message,
  });
}
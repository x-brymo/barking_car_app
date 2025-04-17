// presentation/blocs/booking/booking_event.dart
abstract class BookingEvent {}

class LoadBookings extends BookingEvent {
  final String userId;
  
  LoadBookings({
    required this.userId,
  });
}

class CreateBooking extends BookingEvent {
  final Map<String, dynamic> bookingData;
  
  CreateBooking({
    required this.bookingData,
  });
}

class LoadDashboardStats extends BookingEvent {}
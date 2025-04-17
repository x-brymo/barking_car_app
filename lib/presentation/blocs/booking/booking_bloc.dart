// presentation/blocs/booking/booking_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;
  
  BookingBloc(this._bookingRepository) : super(BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<CreateBooking>(_onCreateBooking);
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }
  
  Future<void> _onLoadBookings(
    LoadBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepository.getUserBookings(event.userId);
      emit(BookingsLoaded(bookings: bookings));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }
  
  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final booking = await _bookingRepository.createBooking(event.bookingData);
      if (booking != null) {
        emit(BookingCreated(booking: booking));
      } else {
        emit(BookingError(message: 'Failed to create booking'));
      }
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }
  
  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final stats = await _bookingRepository.getDashboardStats();
      emit(DashboardStatsLoaded(stats: stats));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }
}
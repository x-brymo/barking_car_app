// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/parking_repository.dart';
import 'data/repositories/booking_repository.dart';
import 'data/services/supabase_service.dart';
import 'data/services/location_service.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/map/map_bloc.dart';
import 'presentation/blocs/booking/booking_bloc.dart';
import 'routes.dart';

class BarkingCarApp extends StatelessWidget {
  final SupabaseService supabaseService;
  
  const BarkingCarApp({super.key, required this.supabaseService});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final authRepository = AuthRepository(supabaseService);
    final locationService = LocationService();
    final parkingRepository = ParkingRepository(supabaseService);
    final bookingRepository = BookingRepository(supabaseService);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository),
        ),
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(parkingRepository, locationService),
        ),
        BlocProvider<BookingBloc>(
          create: (context) => BookingBloc(bookingRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Barking Car App',
        theme: AppTheme.lightTheme,
        initialRoute: Routes.splash,
        routes: Routes.getRoutes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
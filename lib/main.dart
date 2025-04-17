// main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/utils/permission_handler.dart';
import 'data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://yztvytmpqujeccurzyik.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHZ5dG1wcXVqZWNjdXJ6eWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4ODYxMDcsImV4cCI6MjA2MDQ2MjEwN30.S5KDKVGZ1E_K7ZsGTxns_klhcEwp_kzhDGMlhRn9KRE',
  );
  
  // Initialize services
  final supabaseService = SupabaseService();
  await supabaseService.initialize();
  
  runApp(BarkingCarApp(supabaseService: supabaseService));
}
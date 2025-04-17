import 'dart:io';

void main() {
  final basePath = 'lib/';
  final directories = [
    'core/constants',
    'core/theme',
    'core/utils',
    'data/models',
    'data/repositories',
    'data/services',
    'presentation/blocs/auth',
    'presentation/blocs/map',
    'presentation/blocs/booking',
    'presentation/screens/shared',
    'presentation/screens/client',
    'presentation/screens/admin',
    'presentation/widgets',
  ];

  final files = {
    //'main.dart': basePath,
    'app.dart': basePath,
    'core/constants/app_constants.dart': basePath,
    'core/constants/assets_constants.dart': basePath,
    'core/theme/app_theme.dart': basePath,
    'core/utils/location_utils.dart': basePath,
    'data/models/user_model.dart': basePath,
    'data/models/parking_spot_model.dart': basePath,
    'data/models/booking_model.dart': basePath,
    'data/repositories/auth_repository.dart': basePath,
    'data/repositories/parking_repository.dart': basePath,
    'data/repositories/booking_repository.dart': basePath,
    'data/services/supabase_service.dart': basePath,
    'data/services/location_service.dart': basePath,
    'presentation/blocs/auth/auth_bloc.dart': basePath,
    'presentation/blocs/auth/auth_event.dart': basePath,
    'presentation/blocs/auth/auth_state.dart': basePath,
    'presentation/blocs/map/map_bloc.dart': basePath,
    'presentation/blocs/map/map_event.dart': basePath,
    'presentation/blocs/map/map_state.dart': basePath,
    'presentation/blocs/booking/booking_bloc.dart': basePath,
    'presentation/blocs/booking/booking_event.dart': basePath,
    'presentation/blocs/booking/booking_state.dart': basePath,
    'presentation/screens/shared/splash_screen.dart': basePath,
    'presentation/screens/shared/onboarding_screen.dart': basePath,
    'presentation/screens/shared/login_screen.dart': basePath,
    'presentation/screens/shared/register_screen.dart': basePath,
    'presentation/screens/client/home_screen.dart': basePath,
    'presentation/screens/client/booking_screen.dart': basePath,
    'presentation/screens/client/history_screen.dart': basePath,
    'presentation/screens/client/profile_screen.dart': basePath,
    'presentation/screens/admin/dashboard_screen.dart': basePath,
    'presentation/screens/admin/parking_management_screen.dart': basePath,
    'presentation/widgets/custom_button.dart': basePath,
    'presentation/widgets/custom_text_field.dart': basePath,
    'presentation/widgets/parking_marker.dart': basePath,
    'presentation/widgets/booking_card.dart': basePath,
    'routes.dart': basePath,
  };

  for (final dir in directories) {
    final dirPath = '$basePath$dir';
    Directory(dirPath).createSync(recursive: true);
    print('✅ Created directory: $dirPath');
  }

  for (final entry in files.entries) {
    final filePath = '${entry.value}${entry.key}';
    File(filePath).createSync(recursive: true);
    print('📄 Created file: $filePath');
  }

  print('\n🎉 Project structure created successfully!');
}

import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
    print("Permission Granted");
  } else {
    print("Permission Denied");
  }
  if (status.isDenied) {
    // Permission denied, show a message to the user
    print("Location permission is denied. Please enable it in settings.");
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, open app settings
    await openAppSettings();
  }
  if (status.isRestricted) {
    // Permission restricted, show a message to the user
    print("Location permission is restricted. Please check your settings.");
  }
  if (status.isLimited) {
    // Permission limited, show a message to the user
    print("Location permission is limited. Please check your settings.");
  }
  if (status.isProvisional) {
    // Permission undetermined, show a message to the user
    print("Location permission is undetermined. Please check your settings.");
  }
  if (status.isGranted) {
    // Permission granted, proceed with location access
    print("Location permission is granted. You can access the location.");
  } else {
    // Permission denied, show a message to the user
    print("Location permission is denied. Please enable it in settings.");
  }
  if (status.isPermanentlyDenied) {
    // Permission permanently denied, open app settings
    await openAppSettings();
  }
}

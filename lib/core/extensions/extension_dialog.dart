import 'package:flutter/material.dart';

extension ExtensionDialog on BuildContext {
  
  // 1. Show simple alert dialog
  Future<void> showAlertDialog({
    required String title,
    required String content,
    String confirmText = 'OK',
  }) async {
    return showDialog(
      context: this,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(confirmText),
            onPressed: () => Navigator.of(this).pop(),
          ),
        ],
      ),
    );
  }

  // 2. Show a snackbar
  void showSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // 3. Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // 4. Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // 5. Navigate to a new screen
  Future<T?> pushPage<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // 6. Pop current screen
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  // 7. Read theme data
  ThemeData get theme => Theme.of(this);

  // 8. Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // 9. Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // 10. Show bottom sheet
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      builder: (_) => child,
    );
  }
}
snackBarWorld(String title){
  return SnackBar(
    content: Text(title),
    duration: Duration(seconds: 2),
  );
}       
sDEx(BuildContext context, String title, String content){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
    });
}


void sDE(BuildContext context, String title, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger != null) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  } else {
    debugPrint("ScaffoldMessenger not found for context");
  }
}

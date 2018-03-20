// This line imports the extension
import 'package:flutter_driver/driver_extension.dart';
import 'package:maui/main.dart' as app;

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();
  app.main();

  // Call the `main()` of your app or call `runApp` with whatever widget
  // you are interested in testing.
}
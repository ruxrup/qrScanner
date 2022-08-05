import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_scanner/screens/home.dart';

List<CameraDescription> cameras = [];

main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

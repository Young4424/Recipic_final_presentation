import 'package:flutter/material.dart';
import 'package:realtime_object_detection/ml_object_detection/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:realtime_object_detection/screen/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // GetMaterialApp으로 변경
      home: HomeScreen(),
    );
  }
}
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson72/controller/places_controller.dart';
import 'package:lesson72/firebase_options.dart';
import 'package:lesson72/services/location_service.dart';
import 'package:lesson72/utils/extensions.dart';
import 'package:lesson72/views/screens/home_screen.dart';
import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // PermissionStatus cameraPermission = await Permission.camera.status;
  // if (cameraPermission != PermissionStatus.granted) {
  //   cameraPermission = await Permission.camera.request();
  // }
  // print("cameraPermission:$cameraPermission");
  // PermissionStatus smsPermission = await Permission.sms.status;
  // if (smsPermission != PermissionStatus.granted) {
  //   smsPermission = await Permission.sms.request();
  // }
  // print("smsPermission:$smsPermission");
  // PermissionStatus locationPermission = await Permission.location.status;
  // if (locationPermission != PermissionStatus.granted) {
  //   locationPermission = await Permission.location.request();
  // }
  // print(locationPermission);

  ///group permission
  // Map<Permission, PermissionStatus> statuses =
  //     await [Permission.location, Permission.camera].request();
  //     print(statuses);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return PlacesController();
    }, builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      );
    });
  }
}



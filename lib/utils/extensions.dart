import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

extension LocationDataExtensions on LocationData {
  GeoPoint toGeoPoint() {
    return GeoPoint(this.latitude!, this.longitude!);
  }
}



extension FileExtensions on File {
  Future<String> readAsBase64String() async {
    try {
      final bytes = await this.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("Error reading file: $e");
      return '';
    }
  }
}



extension StringToFileExtension on String {
  File toFile() {
    return File(this);
  }
}


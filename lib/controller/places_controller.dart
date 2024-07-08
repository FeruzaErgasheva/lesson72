import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lesson72/services/places_firebase_service.dart';
import 'package:location/location.dart';

class PlacesController extends ChangeNotifier {
  final PlacesFirebaseService _placesFirebaseService = PlacesFirebaseService();
  Stream<QuerySnapshot> get list {
    return _placesFirebaseService.getPlaces();
  }

  Future<void> addLocation(
    String title,
    String description,
    String image,
    GeoPoint location,
  ) {
    notifyListeners();
    return _placesFirebaseService.addLocation(
        title, description, image, location);
  }
}

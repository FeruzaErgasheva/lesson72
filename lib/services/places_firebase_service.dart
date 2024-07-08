import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class PlacesFirebaseService {
  final _placesCollection = FirebaseFirestore.instance.collection("places");

  Stream<QuerySnapshot> getPlaces() async* {
    yield* await _placesCollection.get().asStream();
  }

  Future<void> addLocation(
    String title,
    String description,
    String image,
    GeoPoint location,
  ) {
    return _placesCollection.add({
      "title": title,
      "description": description,
      "imageLink": image,
      "location": location
    });
  }
}

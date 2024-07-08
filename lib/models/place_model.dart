import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class PlaceModel {
  String id;
  dynamic imageLink;
  String title;
  GeoPoint location;
  String description;

  PlaceModel(
      {required this.id,
      required this.description,
      required this.location,
      required this.title,
      required this.imageLink});

  factory PlaceModel.fromJson(QueryDocumentSnapshot query) {
    return PlaceModel(
        id: query.id,
        description: query['description'],
        location: query['location'],
        title: query['title'],
        imageLink: query['imageLink']);
  }
}

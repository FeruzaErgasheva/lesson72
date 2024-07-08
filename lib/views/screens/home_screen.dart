import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lesson72/controller/places_controller.dart';
import 'package:lesson72/models/place_model.dart';
import 'package:lesson72/services/location_service.dart';
import 'package:lesson72/utils/extensions.dart';
import 'package:lesson72/views/widgets/image_pick.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PlacesController placesController;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  dynamic? _selectedImage;
  LocationData? location;

  void watchMyLocation() {}

  void openPlaceBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                if (location != null &&
                    _selectedImage != null &&
                    titleController.text != null &&
                    descriptionController.text != null) {
                  placesController.addLocation(
                      titleController.text,
                      descriptionController.text,
                      _selectedImage.toString(),
                      location!.toGeoPoint());
                }
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "title",
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "description",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      _selectedImage = await showDialog(
                        context: context,
                        builder: (context) {
                          return ImagePickerExample();
                        },
                      );
                    },
                    icon: const Icon(Icons.camera),
                  ),
                  IconButton(
                    onPressed: () async {
                      location = await LocationService.getCurrentLocation();
                      print(location.runtimeType);
                      setState(() {});
                    },
                    icon: Icon(Icons.location_on),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    placesController = context.watch<PlacesController>();
    final myLocatioon = LocationService.currentLOcation;
    print(myLocatioon.runtimeType);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: const Text("Permission Handlers"),
        ),
        body: StreamBuilder(
          stream: placesController.list,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text("Placelar  mavjud emas"),
              );
            }

            final places = snapshot.data!.docs;
            return places.isEmpty
                ? const Center(
                    child: Text("Placelar  mavjud emas"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      itemCount: places.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.7,
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        final place = PlaceModel.fromJson(places[index]);
                        place.imageLink = place.imageLink.contains("http")
                            ? place.imageLink
                            : place.imageLink
                                .replaceFirst("File: '", "")
                                .replaceFirst("'", "");
                        return Card(
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              Expanded(
                                child: place.imageLink.contains("http")
                                    ? Image.network(
                                        place.imageLink,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        place.imageLink.toString().toFile(),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    place.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    place.description,
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 5,
                                  ),
                                  Text(
                                    "${place.location.latitude} : ${place.location.longitude}",
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 5,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openPlaceBox,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

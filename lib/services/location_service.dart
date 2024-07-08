import 'package:location/location.dart';

class LocationService {
  static final _location = Location();
  static bool _isServiceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLOcation;

  static Future<void> init() async {
    await checkService();
    await checkPermission();

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      interval: 1000
    );
  }




//gps ochiqmi tekshirish
  static Future<void> checkService() async {
    _isServiceEnabled = await _location.serviceEnabled();

    if (!_isServiceEnabled) {
      _isServiceEnabled = await _location.requestService();
      if (!_isServiceEnabled) {
        return;

        ///nastroykadan togrlash kerak
      }
    }
  }

//joylashuvni olish uchun ruxsat berilganmi yoqmi tekshiramiz
  static Future<void> checkPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return; //sozlamalardan togirlash kerak boladi
      }
    }
  }

  //lokatsiya olish, agar gps yoqiq bolsa va ruxsat berlgan bolsa
  static Future<LocationData?> getCurrentLocation() async {
    if (_isServiceEnabled && _permissionStatus == PermissionStatus.granted) {
      currentLOcation = await _location.getLocation();
      return currentLOcation;
    }

  }
}

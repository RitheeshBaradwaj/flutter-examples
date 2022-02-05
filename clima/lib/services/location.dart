import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw PlatformException(
          code: 'SERVICE_DISABLED',
          message: 'Location services are not enabled',
          details: null);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Location permissions are denied',
            details: null);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message:
              'Location permissions are permanently denied, we cannot request permissions',
          details: null);
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}

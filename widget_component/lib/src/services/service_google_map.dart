import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapService {
  Future<bool> getLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled() == true;
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await getLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<String?> getAddressFromLatLng(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      // print('address: $placemarks');
      // for (var i = 0; i < placemarks.length; i++) {
      //   debugPrint('$i : ${placemarks[i].toString()}');
      // }
      Placemark placeMark = placemarks[0];
      String? street = placeMark.street;
      String? subAdministrativeArea = placeMark.subAdministrativeArea;
      String? administrativeArea = placeMark.administrativeArea;
      String? country = placeMark.country;
      String? address =
          "$street, $subAdministrativeArea, $administrativeArea, $country";
      return address;
    } catch (e) {
      debugPrint('Address error: $e');
    }
    return null;
  }
}

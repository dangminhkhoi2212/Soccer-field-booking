import 'dart:async';

import 'package:client_app/services/service_address.dart';
import 'package:client_app/utils/util_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/const/colors.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  EditAddressPageState createState() => EditAddressPageState();
}

class EditAddressPageState extends State<EditAddressPage> {
  final double _zoomValue = 13;
  final LatLng _defaultLatLag = const LatLng(10.045162, 105.746857);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final GetStorage _box = GetStorage();
  late String userID;
  final AddressService _addressService = AddressService();
  LatLng? myLatLng;
  LatLng? _currentLatLag;
  Set<Marker> _markers = {};
  CameraPosition? _kGooglePlex;
  String? _currentAddress;

  @override
  initState() {
    super.initState();
    userID = _box.read('id');
    _currentAddress = '';
    _getAddressApiAndInitializeMap();
    _getAddressFromLatLng();
  }

  Future<void> _createMarker() async {
    _markers = {
      Marker(
        markerId: MarkerId(_box.read('id').toString()),
        infoWindow: InfoWindow(
          title: _box.read('name').toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: _currentLatLag ?? _defaultLatLag,
      )
    };
  }

  Future<void> _getMyLocationOnMap() async {
    if (myLatLng != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myLatLng!,
            zoom: _zoomValue,
          ),
        ),
      );
      setState(() {
        _currentLatLag = myLatLng;
        _createMarker();
      });
    }
  }

  Future<void> _getAddressApiAndInitializeMap() async {
    try {
      final result = await _addressService.getAddress(userID: userID);
      print('result: ${result.toString()}');
      if (result == null) return;
      if (result != null) {
        myLatLng = LatLng(result['latitude'], result['longitude']);
        _currentLatLag = myLatLng;
        _createMarker();
        _kGooglePlex = CameraPosition(
          target: _currentLatLag ?? _defaultLatLag,
          zoom: _zoomValue,
        );
        setState(() {});
      }
    } catch (e) {
      print("🚀 ~ _EditAddressPageState ~ FuturegetAddressApi ~ e: $e");
    }
  }

  void _pickPosition(LatLng pickedLatLng) {
    _markers = {
      Marker(
        markerId: const MarkerId('picked_location'),
        infoWindow: const InfoWindow(title: 'Picked Location'),
        icon: BitmapDescriptor.defaultMarker,
        position: pickedLatLng,
      ),
    };
    setState(() {});
  }

  Future<void> _saveAddressApi() async {
    try {
      final data = await _addressService.updateAddress(
          userID: userID,
          lat: _currentLatLag!.latitude,
          long: _currentLatLag!.longitude);
      _getAddressApiAndInitializeMap();
    } catch (e) {
      SnackbarUtil.getSnackBar(
          title: 'Update address.', message: 'Address update failed.');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLatLag!.latitude, _currentLatLag!.longitude);

      Placemark placemark = placemarks[0];
      String? country = placemark.country;
      String? ward = placemarks[3].name;
      String? province = placemark.administrativeArea;
      String? district = placemark.subAdministrativeArea;
      String? sub = placemark.name;

      setState(() {
        _currentAddress = "$sub, $ward, $district, "
            "$province, $country";
      });
    } catch (e) {
      print('address error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update address'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_kGooglePlex != null)
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              onTap: (LatLng latLng) {
                _currentLatLag = latLng;
                _createMarker();
                _getAddressFromLatLng();
                setState(() {});
              },
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 50,
            width: double.infinity,
            child: Text(
              _currentAddress.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 8,
            right: -20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _saveAddressApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const SizedBox(
                    height: 60,
                    width: 60,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _getMyLocationOnMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColor.primary,
                    shape: const CircleBorder(),
                  ),
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: LineIcon.mapMarker(
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

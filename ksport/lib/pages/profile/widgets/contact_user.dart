import 'dart:async';

import 'package:client_app/services/service_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final LatLng _defaultLatLag = const LatLng(10.045162, 105.746857);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final GetStorage _box = GetStorage();
  final AddressService _addressService = AddressService();
  LatLng? myLatLng;
  Set<Marker> _markers = {};
  CameraPosition? _kGooglePlex;

  @override
  initState() {
    super.initState();
    _getAddressApiAndInitializeMap();
  }

  Future<void> _createMarker() async {
    _markers = {
      Marker(
        markerId: MarkerId(_box.read('id').toString()),
        infoWindow: InfoWindow(
          title: _box.read('name').toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: myLatLng ?? _defaultLatLag,
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
            zoom: 14,
          ),
        ),
      );
      setState(() {});
    }
  }

  Future<void> _getAddressApiAndInitializeMap() async {
    try {
      final String userID = _box.read('id').toString();
      final result = await _addressService.getAddress(userID: userID);
      if (result != null) {
        myLatLng = LatLng(result['latitude'], result['longitude']);
        _createMarker();
        _kGooglePlex = CameraPosition(
          target: myLatLng ?? _defaultLatLag,
          zoom: 14,
        );

        // Get.snackbar('get address', result.toString(),
        //     snackPosition: SnackPosition.TOP);
        setState(() {});
      }
    } catch (e) {
      print("🚀 ~ _EditAddressPageState ~ FuturegetAddressApi ~ e: $e");
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
              mapType: MapType.terrain,
              initialCameraPosition: _kGooglePlex!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            ),
          Positioned(
            bottom: 8,
            right: -20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _getMyLocationOnMap,
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

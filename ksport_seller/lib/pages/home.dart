import 'dart:async';

import 'package:ksport_seller/const/colors.dart';
import 'package:ksport_seller/services/service_google_map.dart';
import 'package:ksport_seller/utils/loading.dart';
import 'package:ksport_seller/utils/util_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _box = GetStorage();

  late CameraPosition _kGooglePlex;
  bool _isLoading = false;
  final double _zoomValue = 14.4746;
  late LatLng _myLatLng;
  Set<Marker> _markers = {};
  late String _userID;
  final List<String> _distances = ['500 m', '1 km', '5 km', '10 km', '20 km'];
  late String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _selectedItem = _distances[0];
    _determinePosition();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<void> _createMarker() async {
    _markers = {
      Marker(
        markerId: MarkerId(_userID),
        infoWindow: InfoWindow(
          title: _box.read('name').toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: _myLatLng,
      )
    };
  }

  Future<void> _getMyLocationOnMap() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _myLatLng,
          zoom: _zoomValue,
        ),
      ),
    );
    setState(() {
      _createMarker();
    });
  }

  Future _determinePosition() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final Position? position = await GoogleMapService().determinePosition();
      debugPrint(position!.latitude.toString());
      debugPrint(position.longitude.toString());
      setState(() {
        _myLatLng = LatLng(position.latitude, position.longitude);
        _kGooglePlex = CameraPosition(
          target: _myLatLng,
          zoom: _zoomValue,
        );
        _createMarker();
      });
    } catch (e) {
      SnackbarUtil.getSnackBar(
          title: 'Have an error', message: "Can't get your position");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildButtonTop() {
    return Positioned(
        top: 5,
        left: 15,
        right: 15,
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          // height: 40,
          width: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColor.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton(
              alignment: Alignment.center,
              value: _selectedItem,
              dropdownColor: MyColor.primary,
              focusColor: MyColor.primary,
              isExpanded: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                backgroundColor: MyColor.primary,
              ),
              items: _distances.map((String value) {
                return DropdownMenuItem(
                  alignment: Alignment.center,
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                  _selectedItem = value;
                });
              }),
        ));
  }

  Widget _buildButtonEnd() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _getMyLocationOnMap();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.primary,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20)),
              child: const LineIcon.mapMarker(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: MyLoading.spinkit(size: 60),
            )
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                _buildButtonTop(),
                _buildButtonEnd()
              ],
            ),
    );
  }
}

import 'dart:ui';

import 'package:client_app/routes/route_path.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/const/colors.dart';
import 'package:widget_component/services/service_address.dart';
import 'package:widget_component/services/service_google_map.dart';
import 'package:widget_component/utils/loading.dart';
import 'package:widget_component/utils/util_snackbar.dart';
import 'package:widget_component/widgets/my_image/my_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger();
  final _box = GetStorage();
  final LatLng _defaultLatLag = const LatLng(10.045162, 105.746857);
  late Marker _myMarker = _buildMarker(point: _defaultLatLag);
  late final MapController _mapController = MapController();
  final double _zoom = 14.5;
  late LatLng _currentLatlag;
  late LatLng _myLatlag;
  bool _isLoading = false;
  late String _address = '';
  late String _userID;
  bool _isSubmitting = false;
  late List _addresses;
  final List<Marker> _markers = [];
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _detectMyLocation();
    _getAddressSeller();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  Marker _buildMarker(
      {required LatLng point, String? name, String? src, String? userID}) {
    return Marker(
      width: 40,
      height: 40,
      rotate: true,
      point: point,
      child: PopupMenuButton(
        itemBuilder: (_) => <PopupMenuEntry>[
          PopupMenuItem(
            child: PopupMenuItem(
                onTap: () {
                  if (userID == null) return;
                  Get.toNamed(RoutePaths.seller,
                      parameters: {'userID': userID});
                },
                height: 20,
                child: ListTile(
                  leading: MyImage(
                    height: 50,
                    width: 50,
                    src: src ?? '',
                    isAvatar: true,
                  ),
                  title: Text(name ?? ''),
                )),
          ),
        ],
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset('assets/images/marker.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Future _getAddressSeller() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      final Response? response = await AddressService().getAddress();
      if (response!.statusCode == 200) {
        final dynamic data = response.data;
        logger.d(data);
        if (data is List) {
          for (var address in data) {
            final LatLng point =
                LatLng(address['latitude'], address['longitude']);
            final Marker marker = _buildMarker(
                point: point,
                name: address['userID']['name'],
                src: address['userID']['avatar'],
                userID: address['userID']['_id']);
            _markers.add(marker);
          }
        } else {
          final LatLng point = LatLng(data['latitude'], data['longitude']);
          final Marker marker = _buildMarker(
              point: point,
              name: data['userID']['name'],
              userID: data['userID']['_id']);
          _markers.add(marker);
        }
      }
    } catch (e) {
      logger.e(e);
    }
    setState(() {
      _isLoading = true;
    });
  }

  Future _setLocation(
      {required LatLng point, bool isMoveCamera = false}) async {
    String? address = await GoogleMapService().getAddressFromLatLng(
        latitude: point.latitude, longitude: point.longitude);
    _address = address ?? '';
    _currentLatlag = point;
    _myMarker = _buildMarker(point: point);
    _markers.add(_myMarker);
    if (isMoveCamera) {
      _mapController.move(point, _zoom);
    }
  }

  void _detectMyLocation() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      Position? location = await GoogleMapService().determinePosition();

      if (location != null) {
        LatLng myPoint = LatLng(location.latitude, location.longitude);
        _currentLatlag = _myLatlag = myPoint;
        await _setLocation(point: myPoint, isMoveCamera: true);
      } else {
        _myLatlag = _currentLatlag = _defaultLatLag;
        await _setLocation(point: _currentLatlag, isMoveCamera: true);
      }
    } catch (e) {
      logger.e(e);
    }

    _isLoading = false;
    setState(() {});
  }

  Future _returnMyLocation() async {
    await _setLocation(point: _myLatlag, isMoveCamera: true);
    setState(() {});
  }

  Future _setNewPoint(LatLng point) async {
    await _setLocation(point: point);
    setState(() {});
  }

  Future _handleSaveAddress() async {
    try {
      if (_userID.isEmpty) return;
      setState(() {
        _isSubmitting = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      final Response? response = await AddressService().updateAddress(
          userID: _userID,
          lat: _currentLatlag.latitude,
          long: _currentLatlag.longitude,
          address: _address);
      if (response!.statusCode == 200) {
        SnackbarUtil.getSnackBar(
            title: 'Update address', message: 'Update address successfully');
      } else {
        SnackbarUtil.getSnackBar(
            title: 'Update address', message: 'Have an error.');
      }
    } catch (e) {
      logger.e(error: e, 'Error update address');
      SnackbarUtil.getSnackBar(
          title: 'Update address', message: 'Have an error.');
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget _buildButton() {
    return Positioned(
        bottom: 10,
        right: 5,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _returnMyLocation();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
                backgroundColor: MyColor.primary,
              ),
              child: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  child: const LineIcon.mapMarker(color: Colors.white)),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onMapReady: () {
                _mapController.mapEventStream.listen((evt) {
                  // logger.d(evt);
                });
                // And any other `MapController` dependent non-movement methods
              },
              initialZoom: _zoom,
            ),
            children: [
              _isLoading
                  ? Center(
                      child: MyLoading.spinkit(),
                    )
                  : TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          if (_address != '')
            Positioned(
              top: 5,
              left: 5,
              right: 5,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: MyColor.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Text(
                        _address,
                        // Handle overflow with ellipsis
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
          !_isLoading ? _buildButton() : const SizedBox(),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/other_config.dart';
import 'package:haxuvina/repositories/address_repository.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as loc;

class MapLocation extends StatefulWidget {
  final dynamic address;
  MapLocation({Key? key, this.address}) : super(key: key);

  @override
  State<MapLocation> createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation>
    with SingleTickerProviderStateMixin {
  LatLng? currentLocation;
  GoogleMapController? _controller;
  loc.Location location = loc.Location();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();

    setState(() {
      currentLocation = LatLng(
        _locationData.latitude ?? 21.0285,
        _locationData.longitude ?? 105.8542,
      );
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  void onTapPickHere() async {
    if (currentLocation == null) return;

    var placemarks = await geocoding.placemarkFromCoordinates(
        currentLocation!.latitude, currentLocation!.longitude);

    var result = await AddressRepository().getAddressUpdateLocationResponse(
      widget.address.id,
      currentLocation!.latitude,
      currentLocation!.longitude,
    );

    ToastComponent.showDialog(result.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.your_delivery_location),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: currentLocation!, zoom: 16),
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            onCameraMove: (position) {
              currentLocation = position.target;
            },
          ),
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Btn.basic(
              color: MyTheme.accent_color,
              child: Text(
                AppLocalizations.of(context)!.pick_here,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: onTapPickHere,
            ),
          ),
          Center(
            child: Icon(Icons.location_pin, size: 40, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

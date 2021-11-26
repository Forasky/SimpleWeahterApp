import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final ValueChanged<LatLng> onLocationTab;
  MapSample({
    Key? key,
    required this.onLocationTab,
  }) : super();
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Marker _marker = Marker(
    markerId: MarkerId('Minsk'),
  );

  static final CameraPosition _belarus = CameraPosition(
    target: LatLng(53.910981510269075, 27.547882162034508),
    zoom: 6,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          LocalizationKeys.weatherMap,
        ),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        markers: {
          _marker,
        },
        onTap: _addMarker,
        mapType: MapType.normal,
        initialCameraPosition: _belarus,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => widget.onLocationTab(_marker.position),
        label: Text(
          LocalizationKeys.getWeather,
        ),
        icon: Icon(
          FontAwesomeIcons.plus,
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    setState(() {
      _marker = Marker(
        markerId: MarkerId('origin'),
        position: pos,
      );
    });
  }
}

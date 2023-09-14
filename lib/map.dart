import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'location_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(42.004143174784026, 21.40976152045983),
    zoom: 13.5,
  );

  GoogleMapController _googleMapController;
  static final Marker _MobilniAplikacii = Marker(
    markerId: MarkerId('_MobilniAplikacii'),
    infoWindow:
        InfoWindow(title: "Мобилни апликации", snippet: "2023-02-27 16:30"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(42.003991, 21.410320),
  );

  static final Marker _MIS = Marker(
    markerId: MarkerId('_MIS'),
    infoWindow: InfoWindow(
        title: "Менаџмент информациски системи", snippet: "2023-02-28 14:00"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(42.00411125598645, 21.41082367332613),
  );

  static final Marker _Kalkulus = Marker(
    markerId: MarkerId('_Kalkulus'),
    infoWindow: InfoWindow(title: "Калкулус", snippet: "2023-03-03 17:00"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(42.00442224094337, 21.407036406986997),
  );

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.004143174784026, 21.40976152045983),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(42.004143174784026, 21.40976152045983));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      decoration: InputDecoration(hintText: ' Origin'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextFormField(
                      controller: _destinationController,
                      decoration: InputDecoration(hintText: ' Destination'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  var directions = await LocationService().getDirections(
                    _originController.text,
                    _destinationController.text,
                  );
                  _goToPlace(
                    directions['start_location']['lat'],
                    directions['start_location']['lng'],
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                  );

                  _setPolyline(directions['polyline_decoded']);
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {_MIS, _Kalkulus, _MobilniAplikacii},
              polygons: _polygons,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place,
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GoogleMap(
  //       myLocationButtonEnabled: false,
  //       zoomControlsEnabled: false,
  //       initialCameraPosition: _initialCameraPosition,
  //       onMapCreated: (controller) => _googleMapController = controller,
  //       markers: {
  //         _MobilniAplikacii,
  //         _MIS,
  //         _Kalkulus,
  //       },
  //     ),
  //   );
  // }
}

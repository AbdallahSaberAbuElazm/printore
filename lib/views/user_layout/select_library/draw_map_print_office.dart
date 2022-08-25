// import 'dart:collection';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:printore/views/user_layout/select_library/helpers.dart/map_helper.dart';
// import 'package:printore/views/user_layout/select_library/locating.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class DrawMapPrintOffice extends StatefulWidget {
//   const DrawMapPrintOffice({Key? key}) : super(key: key);

//   @override
//   State<DrawMapPrintOffice> createState() => _DrawMapPrintOfficeState();
// }

// class _DrawMapPrintOfficeState extends State<DrawMapPrintOffice> {
//   final _markers = HashSet<Marker>();
//   //  final BitmapDescriptor markerImage =
//   //         await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

//   getCustomMarker() async {
//     BitmapDescriptor customMarker ;
//     final markerImageFile = await DefaultCacheManager().getSingleFile('');
//     final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
//     final Codec markerImageCodec = await instantiateImageCodec(
//       markerImageBytes,
//       targetWidth: 20,
//     );
//     final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
//     final ByteData? byteData = await frameInfo.image.toByteData(
//       format: ImageByteFormat.png,
//     );
//     final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
//     customMarker = BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
//   }

//   Future<bool> _onWillPop() async {
//     return (await Get.off(const Locating())) ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           body: Stack(
//             children: [
//               GoogleMap(
//                 initialCameraPosition: const CameraPosition(
//                   target: LatLng(30.588785, 31.480908),
//                   zoom: 17,
//                 ),
//                 onMapCreated: (GoogleMapController googleMapController) {
//                   setState(() {
//                     _markers.add(const Marker(
//                         markerId: MarkerId('1'),
//                         position: LatLng(30.588785, 31.480908),
//                         infoWindow: InfoWindow(title: 'مكتبة الأصدقاء')));
//                     _markers.add(
//                       const Marker(
//                         markerId: MarkerId('2'),
//                         position: LatLng(30.589801, 31.48138),
//                         infoWindow: InfoWindow(
//                           title: 'مكتبة الراعي',
//                         ),
//                       ),
//                     );
//                     _markers.add(const Marker(
//                         markerId: MarkerId('3'),
//                         position: LatLng(30.590896, 31.47917),
//                         infoWindow: InfoWindow(title: 'مكتبة السلام')));
//                   });
//                 },
//                 markers: _markers,
//                 padding: const EdgeInsets.only(bottom: 80),
//               ),
//               Align(
//                 alignment: FractionalOffset.bottomCenter,
//                 child: Container(
//                   width: double.infinity,
//                   // height: 55,
//                   padding:
//                       const EdgeInsets.only(left: 12, right: 12, bottom: 15),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           height: 55,
//                           child: ElevatedButton(
//                               onPressed: () => Get.off(() => const Locating()),
//                               child: const Text(
//                                 'العودة الي مكاتب الطباعة',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 17),
//                               )),
//                         ),
//                         SizedBox(
//                           height: 55,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               return null;
//                             },
//                             child: const Text(
//                               'إستمرار',
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 17),
//                             ),
//                           ),
//                         ),
//                       ]),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/user_layout/select_library/helpers.dart/map_helper.dart';
import 'package:printore/views/user_layout/select_library/helpers.dart/map_marker.dart';

class DrawMapPrintOffice extends StatefulWidget {
  @override
  _DrawMapPrintOfficeState createState() => _DrawMapPrintOfficeState();
}

class _DrawMapPrintOfficeState extends State<DrawMapPrintOffice> {
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
  ];

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Styles.appBarText('مواقع مقدمي خدمة الطباعة', context),
      ),
      body: Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: GoogleMap(
              mapToolbarEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(41.143029, -8.611274),
                zoom: _currentZoom,
              ),
              markers: _markers,
              onMapCreated: (controller) => _onMapCreated(controller),
              onCameraMove: (position) => _updateMarkers(position.zoom),
            ),
          ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'تحميل',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

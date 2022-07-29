import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:printore/views/user_layout/select_library/locating.dart';

class DrawMapPrintOffice extends StatefulWidget {
  const DrawMapPrintOffice({Key? key}) : super(key: key);

  @override
  State<DrawMapPrintOffice> createState() => _DrawMapPrintOfficeState();
}

class _DrawMapPrintOfficeState extends State<DrawMapPrintOffice> {
  final _markers = HashSet<Marker>();
  Future<bool> _onWillPop() async {
    return (await Get.off(const Locating())) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(30.588785, 31.480908),
                  zoom: 17,
                ),
                onMapCreated: (GoogleMapController googleMapController) {
                  setState(() {
                    _markers.add(const Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(30.588785, 31.480908),
                        infoWindow: InfoWindow(title: 'مكتبة الأصدقاء')));
                    _markers.add(
                      const Marker(
                        markerId: MarkerId('2'),
                        position: LatLng(30.589801, 31.48138),
                        infoWindow: InfoWindow(
                          title: 'مكتبة الراعي',
                        ),
                      ),
                    );
                    _markers.add(const Marker(
                        markerId: MarkerId('3'),
                        position: LatLng(30.590896, 31.47917),
                        infoWindow: InfoWindow(title: 'مكتبة السلام')));
                  });
                },
                markers: _markers,
                padding: const EdgeInsets.only(bottom: 80),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  width: double.infinity,
                  // height: 55,
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                              onPressed: () => Get.off(() => const Locating()),
                              child: const Text(
                                'العودة الي مكاتب الطباعة',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                        ),
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              return null;
                            },
                            child: const Text(
                              'إستمرار',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

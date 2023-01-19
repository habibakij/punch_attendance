
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:attendance/common/style_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import 'package:get/get.dart';
import '../common/utils.dart';
import '../controller/home_controller.dart';
import '../domain/database/firebase_database.dart';
import 'button_widet.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PunchButtonPopUp extends StatefulWidget {
  const PunchButtonPopUp({Key? key}) : super(key: key);
  @override
  State<PunchButtonPopUp> createState() => _PunchButtonPopUpState();
}

class _PunchButtonPopUpState extends State<PunchButtonPopUp> {

  final appController= Get.put(HomeController());
  TextEditingController noteController= TextEditingController();

  /// time data
  var timeOne, timeTwo;
  TimeOfDay? punchInTime;
  Future<void> _selectPunchIn(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timePicked != null) {
      punchInTime = timePicked;
    }
    DateTime tempDate = DateFormat("hh:mm").parse("${punchInTime!.hour}:${punchInTime!.minute}");
    var dateFormat = DateFormat("h:mm a");
    appController.punchInTime.value= dateFormat.format(tempDate);
    //timeOne= dateFormat.format(tempDate);
  }
  TimeOfDay? punchOutTime;
  Future<void> _selectPunchOut(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timePicked != null) {
      punchOutTime = timePicked;
    }
    DateTime tempDate = DateFormat("hh:mm").parse("${punchOutTime!.hour}:${punchOutTime!.minute}");
    var dateFormat = DateFormat("h:mm a");
    timeTwo= dateFormat.format(tempDate);
    appController.punchOutTime.value= dateFormat.format(tempDate);
    log("full_time: ${appController.punchInTime.value}, $timeTwo");
    _totalHour(appController.punchInTime.value, timeTwo);
  }
  void _totalHour(String timeOne, String timeTwo){
    var format = DateFormat("h:mm a");
    var one = format.parse(timeOne);
    var two = format.parse(timeTwo);
    var min= two.difference(one).inMinutes.toString();
    int positiveMin= int.parse(min).abs();
    if(positiveMin < 60 ){
      appController.totalHour.value= "0";
      appController.totalMin.value= positiveMin.toString();
    } else {
      int hour = positiveMin ~/ 60;
      var min2 = positiveMin % 60;
      appController.totalHour.value= "$hour";
      appController.totalMin.value= min2.toString();
    }
  }

  /// map data
  final Completer<GoogleMapController> mapController = Completer();
  MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition= const CameraPosition(target: LatLng(23.751869, 90.384082), zoom: 14);
  final List<Marker> _marker = <Marker>[];
  Future<Position> currentLocation() async {
    await Geolocator.requestPermission().then((value) => {}).onError((error, stackTrace) {
      throw "error: $error";
    });
    return await Geolocator.getCurrentPosition();
  }

  loadLocation() {
    currentLocation().then((value) async {
      log("current_lat_long: ${value.latitude} and ${value.longitude}");
      _marker.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: "Current Location"),
        ),
      );
      cameraPosition= CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 14);
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark1 = placemark[0];
    appController.address.value = "${placemark1.street.toString()}, ${placemark1.locality.toString()}, ${placemark1.isoCountryCode.toString()}, ${placemark1.postalCode.toString()} ";
    log("current_address: ${appController.address.value}");
  }

  Future getIPAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        appController.ipAddress.value= address.address;
        appController.ipVersion.value= address.type.name;
      }
    }
  }

  late Timer timer;
  void mapReady(){
    timer = Timer(const Duration(seconds:2),(){
      appController.mapExecute.value= true;
    });
  }

  @override
  void initState() {
    super.initState();
    mapReady();
    getIPAddress();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 60,
                height: 6,
              ),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 60,
                height: 6,
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 60,
                height: 6,
              ),

            ],
          ),
          const SizedBox(height: 5),
          /// pop dialog app bar
          Card(
            margin: EdgeInsets.zero,
            elevation: 1,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Punch In",
                    style: StyleManagement.popUpHeaderStyle,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close, size: 30, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          /// pop dialog body

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("In", style: StyleManagement.popUpPunchTextStyle),
                              const SizedBox(height: 10),
                              InkWell(
                                child: Obx(() => Text(
                                  appController.punchInTime.value.isEmpty ? "-- AM" : appController.punchInTime.value,
                                  style: StyleManagement.popUpPunchInStyle,
                                )),
                                onTap: (){
                                  _selectPunchIn(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(margin: const EdgeInsets.only(right: 20),height: 30, width: 1, color: Colors.white),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("Out", style: StyleManagement.popUpPunchTextStyle),
                              const SizedBox(height: 10),
                              InkWell(
                                child: Obx(() => Text(
                                  appController.punchOutTime.value.isEmpty ? "-- PM" : appController.punchOutTime.value,
                                  style: StyleManagement.popUpPunchInStyle,
                                )),
                                onTap: (){
                                  if(appController.punchInTime.value.isEmpty){
                                    Utils.showToast("Select In Time");
                                  } else {
                                    _selectPunchOut(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        Container(margin: const EdgeInsets.only(right: 20), height: 30, width: 1, color: Colors.white),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("Total", style: StyleManagement.popUpPunchTextStyle),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Obx(() => Text(
                                    appController.totalHour.value.isEmpty ? "0" : appController.totalHour.value,
                                    style: StyleManagement.popUpPunchInStyle),
                                  ),
                                  const Text("h ", style: StyleManagement.popUpPunchTextStyle),
                                  Obx(() => Text(
                                    appController.totalMin.value.isEmpty ? "0" : appController.totalMin.value,
                                    style: StyleManagement.popUpPunchInStyle),
                                  ),
                                  const Text("m", style: StyleManagement.popUpPunchTextStyle),
                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Note (optional)",style: StyleManagement.popUpNoteTextStyle),
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: const Color(0xFFB2BAFF)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: noteController,
                        maxLines: 150 ~/ 20,
                        decoration: const InputDecoration(
                          hintText: "Add note here",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 150,
                      child: MapPicker(
                        iconWidget: const Icon(Icons.location_on_outlined, size: 30, color: Colors.blue),
                        mapPickerController: mapPickerController,
                        child: GoogleMap(
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          initialCameraPosition: cameraPosition,
                          onMapCreated: (GoogleMapController controller) async {
                            mapController.complete(controller);
                          },
                          onCameraMoveStarted: () {
                            mapPickerController.mapMoving!();
                          },
                          onCameraMove: (position) {
                            cameraPosition = position;
                            getAddressFromLatLong(cameraPosition.target.latitude, cameraPosition.target.longitude);
                          },
                          onCameraIdle: () async {
                            mapPickerController.mapFinishedMoving!();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.withOpacity(.2),
                          ),
                          child: const Icon(Icons.my_location_sharp, size: 24, color: Colors.blue,),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Card(
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget> [
                                Obx(() => Text(
                                  appController.address.value,
                                  style: StyleManagement.popUpAddressTextStyle,
                                )),
                                const Text(
                                  "My Location",
                                  style: StyleManagement.popUpLocationTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.withOpacity(.2),
                          ),
                          child: const Icon(Icons.location_on_outlined, size: 24, color: Colors.blue,),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                              "${appController.ipAddress.value}, ${appController.ipVersion.value}",
                              style: StyleManagement.popUpAddressTextStyle,
                            )),
                            const Text(
                              "IP Address",
                              style: StyleManagement.popUpLocationTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ButtonWidget(title: "Cancel", color: "1"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 50,
                            child: Obx(() => ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                backgroundColor: appController.punchInTime.value.isEmpty ?
                                MaterialStateProperty.all<Color>(Colors.green) : MaterialStateProperty.all<Color>(Colors.orange),
                              ),
                              onPressed: (){
                                if(appController.punchOutTime.value.isEmpty){
                                  Utils.showToast("select punch out");
                                } else {
                                  EasyLoading.show(status: "uploading...");
                                  String totalHour= "${appController.totalHour.value}h ${appController.totalMin.value}m";
                                  String deviceIP= "${appController.ipAddress.value}, ${appController.ipVersion.value}";
                                  FirebaseData.insertData(
                                    appController.punchInTime.value.toString(),
                                    appController.punchOutTime.value.toString(),
                                    totalHour,
                                    noteController.text.toString(),
                                    appController.address.value.toString(),
                                    deviceIP,
                                    appController.address.value.toString(),
                                    deviceIP,
                                  );
                                  EasyLoading.dismiss();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                appController.punchInTime.value.isEmpty ? "Punch In" : "Punch Out",
                                style: StyleManagement.popUpPunchBtnTextStyle,
                              ),
                            )),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }



}


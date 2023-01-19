
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/style_management.dart';
import '../common/utils.dart';
import '../controller/home_controller.dart';
import 'button_widet.dart';

class LogDetailsPopUp extends StatelessWidget {
  String punchIn= "", punchOut= "", totalHour= "", inLocation= "", inIp= "", note, outLocation= "", outIp= "";
  LogDetailsPopUp({super.key, required this.punchIn, required this.punchOut, required this.totalHour, required this.inLocation,
    required this.inIp, required this.note, required this.outLocation, required this.outIp});

  final appController= Get.put(HomeController());

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
                    "Log Details",
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
                  children: <Widget> [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          appController.currentDate.value,
                          style: StyleManagement.popUpDetailsTextStyle,
                        ),

                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            onPressed: (){
                              Utils.showToast("Regular");
                            },
                            child: const Text(
                              "Regular",
                              style: StyleManagement.regularTextStyle,
                            ),
                          ),
                        ),

                      ],
                    ),
                    const Text(
                      "Auto",
                      style: StyleManagement.popUpLocationTextStyle,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("In", style: StyleManagement.popUpPunchTextStyle),
                              const SizedBox(height: 5),
                              Text(punchIn, style: StyleManagement.popUpPunchInStyle),
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
                              const SizedBox(height: 5),
                              Text(punchOut, style: StyleManagement.popUpPunchInStyle),
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
                              const SizedBox(height: 5),
                              Text(totalHour, style: StyleManagement.popUpPunchInStyle),

                            ],
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Punch In", style: StyleManagement.popUpNoteTextStyle),
                    const SizedBox(height: 10),
                    const Text(
                      "Late entry because of heavy traffic jam",
                      style: StyleManagement.popUpAddressTextStyle,
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
                              children: [
                                Text(
                                  inLocation,
                                  style: StyleManagement.popUpAddressTextStyle,
                                ),
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
                            Text(
                              inIp,
                              style: StyleManagement.popUpAddressTextStyle,
                            ),
                            const Text(
                              "IP Address",
                              style: StyleManagement.popUpLocationTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Punch Out", style: StyleManagement.popUpNoteTextStyle),
                    const SizedBox(height: 10),
                    Text(
                      note,
                      style: StyleManagement.popUpDetailsTextStyle,
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
                              children: [
                                Text(
                                  outLocation,
                                  style: StyleManagement.popUpAddressTextStyle,
                                ),
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
                            Text(
                              outIp,
                              style: StyleManagement.popUpAddressTextStyle,
                            ),
                            const Text(
                              "IP Address",
                              style: StyleManagement.popUpLocationTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("API Fetch data jsonplace holder", style: StyleManagement.popUpNoteTextStyle),
                    const SizedBox(height: 10),
                    Column(
                      children: <Widget> [
                        Row(
                          children: <Widget> [
                            const Expanded(
                              flex: 1,
                              child: Text("ID"),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(appController.dataModel.value.id.toString()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget> [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Title",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                appController.dataModel.value.title.toString(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget> [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Body",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                appController.dataModel.value.body.toString(),
                                textAlign: TextAlign.start,
                              ),                                                        ),
                          ],
                        ),
                      ],
                    ),


                    const SizedBox(height: 30),
                    Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: ButtonWidget(title: "Change Logs", color: "1"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: ButtonWidget(title: "Edit", color: "2"),
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

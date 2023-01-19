
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/style_management.dart';
import '../common/utils.dart';
import '../controller/home_controller.dart';
import '../widget/date_time_loader.dart';
import '../widget/log_details_pop_up.dart';
import '../widget/punch_button_pop_up.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final appController= Get.put(HomeController());
  var now= DateTime.now();
  var formatter= DateFormat.yMMMMd('en_US');

  void _currentDate(){
    appController.currentDate.value= formatter.format(now);
  }

  int _selectedTab = 0;
  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  final reference= FirebaseDatabase.instance.ref("attendance");

  @override
  void initState() {
    super.initState();
    _currentDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 40,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/image/payday.PNG",
                  height: 50,
                  width: 100,
                ),
              ),
              InkWell(
                child: const Icon(
                  Icons.notifications_none,
                  size: 25,
                  color: Colors.blue,
                ),
                onTap: (){
                  Utils.showToast("Notification");
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.topLeft,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Hi, Steave",
                          style: StyleManagement.bigWhiteTextStyle,
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

                    Obx(() => Text(
                      appController.currentDate.value.toString(),
                      style: StyleManagement.homeTextStyle,
                    )),

                    Container(
                      height: 200,
                      //width: 100,
                      alignment: Alignment.center,
                      child: DateTimeLoader(),
                    ),

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("In", style: StyleManagement.homeTextStyle),
                              const SizedBox(height: 10),
                              Obx(() => Text(
                                appController.punchInTime.value.isEmpty ? "--" : appController.punchInTime.value,
                                style: StyleManagement.homePunchInStyle,
                              )),
                            ],
                          ),
                        ),
                        Container(margin: const EdgeInsets.only(right: 20),height: 30, width: 1, color: Colors.white),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("Out", style: StyleManagement.homeTextStyle),
                              const SizedBox(height: 10),
                              Obx(() => Text(
                                appController.punchOutTime.value.isEmpty ? "--" : appController.punchOutTime.value,
                                style: StyleManagement.homePunchInStyle,
                              )),
                            ],
                          ),
                        ),

                        Container(margin: const EdgeInsets.only(right: 20), height: 30, width: 1, color: Colors.white),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("Balance", style: StyleManagement.homeTextStyle),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Obx(() => Text(
                                    appController.totalHour.value.isEmpty ? "0" : appController.totalHour.value,
                                    style: StyleManagement.homePunchInStyle,
                                  )),
                                  const Text("h ", style: StyleManagement.homeTextStyle),
                                  Obx(() => Text(
                                    appController.totalMin.value.isEmpty ? "0" : appController.totalMin.value,
                                    style: StyleManagement.homePunchInStyle,
                                  )),
                                  const Text("m", style: StyleManagement.homeTextStyle),
                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),

                    InkWell(
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.lightBlue,
                          border: Border.all(color: Colors.white),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, size: 25, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Obx(() => Text(
                              appController.punchInTime.value.isEmpty ? "Punch In" : "Punch Out",
                              style: StyleManagement.popUpPunchBtnTextStyle,
                            )),
                          ],
                        ),
                      ),
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context){
                            return DelayedDisplay(
                              delay: const Duration(milliseconds: 500),
                              child: DraggableScrollableSheet(
                                initialChildSize: 0.85,
                                minChildSize: 0.2,
                                maxChildSize: 1,
                                expand: true,
                                builder: (con , ind){
                                  return const PunchButtonPopUp();
                                },
                              ),
                            );
                          }
                        );

                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          height: 8,
                          width: 30,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),

                        Container(
                          height: 8,
                          width: 8,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),


                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [

                          Text("Attendance Logs", style: StyleManagement.homeTextStyle),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_forward, size: 15, color: Colors.white,),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  "Today's Logs",
                  style: StyleManagement.popUpNoteTextStyle,
                ),
              ),

              SizedBox(
                height: 210,
                child: StreamBuilder(
                  stream: reference.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
                    if(!snapshot.hasData){
                      return const Center(child: Text("No logs found"));
                    } else {
                      Map<dynamic, dynamic> map= snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> dataList= [];
                      dataList.clear();
                      dataList= map.values.toList();
                      return ListView.builder(
                        //shrinkWrap: true,
                        //physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: ((context, index){
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        "${dataList[index][Utils.PUNCHIN].toString()} - ${dataList[index][Utils.PUNCHOUT].toString()}",
                                        style: StyleManagement.listTitleTextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.watch_later_outlined,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            dataList[index][Utils.TOTALHOUR].toString(),
                                            style: StyleManagement.listSubTitleTextStyle,
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.text_snippet_outlined,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            "0",
                                            style: StyleManagement.listSubTitleTextStyle,
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),

                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 30,
                                    color: Colors.blue,
                                  )

                                ],
                              ),
                            ),
                            onTap: (){
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context){
                                    return DelayedDisplay(
                                      delay: const Duration(milliseconds: 500),
                                      child: DraggableScrollableSheet(
                                        initialChildSize: 0.85,
                                        minChildSize: 0.2,
                                        maxChildSize: 1,
                                        expand: true,
                                        builder: (con,ind){
                                          return LogDetailsPopUp(
                                            punchIn: dataList[index][Utils.PUNCHIN].toString(),
                                            punchOut: dataList[index][Utils.PUNCHOUT].toString(),
                                            totalHour: dataList[index][Utils.TOTALHOUR].toString(),
                                            inLocation: dataList[index][Utils.INLOCATION].toString(),
                                            inIp: dataList[index][Utils.INIP].toString(),
                                            note: dataList[index][Utils.NOTE].toString(),
                                            outLocation: dataList[index][Utils.OUTLOCATION].toString(),
                                            outIp: dataList[index][Utils.OUTIP].toString(),
                                          );
                                        },
                                      ),
                                    );
                                  }
                              );
                            },
                          );
                        }),
                      );
                    }
                  },
                ),
              ),


           /*   ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){

                },
              ),*/

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.access_time_filled_outlined, size: 24), label: 'Attendance', backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month, size: 24), label:'Leave', backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.text_snippet_outlined, size: 24), label: 'Payslip', backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_rounded, size: 24), label: 'More', backgroundColor: Colors.white),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedTab,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          iconSize: 40,
          onTap: (index) => _changeTab(index),
          elevation: 5
      ),
    );
  }

}

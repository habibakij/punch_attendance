
import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:get/get.dart';
import '../common/style_management.dart';
import '../controller/home_controller.dart';

class DateTimeLoader extends StatelessWidget {

  final appController= Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SemicircularIndicator(
      radius: 100,
      color: Colors.white,
      backgroundColor: Colors.lightBlue,
      strokeWidth: 15,
      bottomPadding: 0,
      progress: calculateProgress(),
      userDefaultChildPosition: true,
      contain: true,
      child: SizedBox(
        height: 120,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 10),
            const Text("Worked", style: StyleManagement.homeTextStyle),
          ],
        ),
      ),
    ));
  }

  double calculateProgress(){
    int hour;
    int minute;
    if(appController.totalHour.value.isEmpty || appController.totalMin.value.isEmpty){
      hour= 0;
      minute= 0;
    } else {
      hour= int.parse(appController.totalHour.value);
      minute= int.parse(appController.totalMin.value);
    }
    int totalMin= (hour * 60) + minute;
    double percentage= ((totalMin * 100) / 540);
    double percent= percentage / 100;
    String len= percent.toStringAsFixed(2);
    return double.parse(len);
  }

}


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:attendance/model/data_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import '../common/utils.dart';
import '../domain/network/app_url.dart';
import '../domain/network/interceptor.dart';

class HomeController extends GetxController {

  http.Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  @override
  void onInit() {
    super.onInit();
    getProductList();
  }

  RxString address = "".obs, ipAddress= "".obs, ipVersion= "".obs, punchInTime= "".obs, punchOutTime= "".obs, totalHour= "".obs, totalMin= "".obs, currentDate= "".obs;
  RxBool mapExecute= false.obs;


  Rx<DataModel> dataModel= DataModel().obs;
  Future<void> getProductList() async{
    try{
      EasyLoading.show(status: "Please wait...");
      var response= await client.get(Uri.parse(AppUrl.DETAILSURL));
      if(response.statusCode == 200 || response.statusCode == 201){
        EasyLoading.dismiss();
        dataModel.value= DataModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error fetching. \n ${response.statusCode}, ${response.body}");
      }
    } on SocketException {
      EasyLoading.dismiss();
      throw Utils.showToast("Connection error, Please try again");
    } on FormatException {
      EasyLoading.dismiss();
      throw Utils.showToast("Bad request, Please try again");
    } on TimeoutException {
      EasyLoading.dismiss();
      throw Utils.showToast("Timeout, Please try again");
    }
  }
  
}

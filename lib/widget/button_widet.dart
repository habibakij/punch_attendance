
import 'package:flutter/material.dart';
import '../common/style_management.dart';

class ButtonWidget extends StatelessWidget {
  String title= "", color= "";
  ButtonWidget({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          backgroundColor: color == "1" ? MaterialStateProperty.all<Color>(Colors.white) : MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text(title, style: StyleManagement.popUpCancelTextStyle),
      ),
    );
  }
}

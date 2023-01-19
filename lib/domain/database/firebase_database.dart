
import 'package:firebase_database/firebase_database.dart';
import '../../common/utils.dart';

class FirebaseData{

  static DatabaseReference databaseReference= FirebaseDatabase.instance.ref().child("attendance");

  static void insertData(String punchIn, String punchOut, String totalHour, String note, String inLocation,
      String inIp, String outLocation, String outIp){
    Map<String, dynamic> mapData= {
      Utils.PUNCHIN : punchIn,
      Utils.PUNCHOUT : punchOut,
      Utils.TOTALHOUR : totalHour,
      Utils.NOTE : note,
      Utils.INLOCATION : inLocation,
      Utils.INIP : inIp,
      Utils.OUTLOCATION : outLocation,
      Utils.OUTIP : outIp
    };
    databaseReference.push().set(mapData);
  }

}
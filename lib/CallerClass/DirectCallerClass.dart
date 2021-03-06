import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class DirectCallerClass {
  callNumber() async {
    try {
      String number = '011 894 7333'; //set the number here
      await (FlutterPhoneDirectCaller.callNumber(number))
          .whenComplete(() => EmergencyType());
    } catch (e) {
      Fluttertoast.showToast(msg: "$e").whenComplete(() => EmergencyType());
      logger.i("$e");
      throw ("Error: $e");
    }
  }

  callFireFighterNumber() async {
    try {
      String number = "0800055555";
      await (FlutterPhoneDirectCaller.callNumber(number)).whenComplete(
        () => EmergencyType(),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "$e").whenComplete(() => EmergencyType());
      throw ("Error: $e");
    }
  }

  callPoliceNumber() async {
    try {
      String number = "10111";
      await (FlutterPhoneDirectCaller.callNumber(number)).whenComplete(
        () => EmergencyType(),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "$e").whenComplete(
        () => EmergencyType(),
      );
      throw ("Error: $e");
    }
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMMM yyyy').format(dateFromTimeStamp);
  }

  String formattedTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);
    print(formattedTime);
    return formattedTime;
  }
}

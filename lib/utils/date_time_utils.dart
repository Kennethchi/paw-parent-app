import 'package:intl/date_time_patterns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class DateTimeUtils{

  static String getTimeFromTimestampType_jm(Timestamp timestamp){

    DateTime dateTime = timestamp.toDate();

    return DateFormat.jm().format(dateTime);
  }


  static String getTimeFromTimestampType_Hm(Timestamp timestamp){

    DateTime dateTime = timestamp.toDate();

    return DateFormat.Hm().format(dateTime);
  }


  static String getTimeFromMillisecondsSinceEpochType_jm(int milliseconds){

    DateTime dateTime = Timestamp.fromMillisecondsSinceEpoch(milliseconds).toDate();

    return DateFormat.jm().format(dateTime);
  }


  static String getTimeFromMillisecondsSinceEpochType_Hm(int milliseconds){

    DateTime dateTime = Timestamp.fromMillisecondsSinceEpoch(milliseconds).toDate();

    return DateFormat.Hm().format(dateTime);
  }



  static String getTimeFromSeconds(int seconds){

    int hourInSeconds = 60 * 60;
    int hours = (seconds / hourInSeconds).round();



    if (seconds >= hourInSeconds){
      return DateFormat.Hms().format(DateTime(0, 0, 0, 0, 0, seconds, 0));
    }
    else if (seconds >= hourInSeconds * 24){
      return hours.toString() + ":" + DateFormat.ms().format(DateTime(0, 0, 0, 0, 0, seconds, 0));
    }
    else{
      return DateFormat.ms().format(DateTime(0, 0, 0, 0, 0, seconds, 0));
    }


  }


}
import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';



class BasicUtils{


  static Future<bool> getIsInternetConnectionAvailable()async{

    String cloudfareAddress = "1.1.1.1";
    String googleAddress1 = "8.8.8.8";
    String googleAddress2 = "8.8.4.4";
    String openDns = "208.67.222.222";

    int port = 53;
    Duration timeoutDuration = Duration(seconds: 1);

    /*
    try {
      List<InternetAddress> result = await InternetAddress.lookup("google.com");

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        return true;
      }
    } on SocketException catch (_) {
      print('not connected');

      return false;
    }
    */

    Socket sock;
    try {
      sock = await Socket.connect(
        googleAddress1,
        port,
        timeout: timeoutDuration,
      );

      sock?.destroy();
      return true;
    } catch (e) {

      sock?.destroy();
      return false;
    } finally{

      sock?.destroy();
    }

    return false;
  }

  Future<bool> isAppFirstRun()async{

    PackageInfo packageInfo =  await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isFirstRun = prefs.getBool(packageInfo.packageName);

    if (isFirstRun)
      return true;
    else
      return false;
  }




  static Future<File> generateFileFromAssets({@required String assetPath})async{

    Directory directory = await getTemporaryDirectory();
    String filePath = directory.path + "/" + "${DateTime.now().microsecondsSinceEpoch}";

    File file = File(filePath);

    ByteData byteData = await rootBundle.load(assetPath);

    final buffer = byteData.buffer;
    return await File(filePath).writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

}


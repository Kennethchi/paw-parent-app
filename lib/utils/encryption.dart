

import 'package:crypt/crypt.dart';
import 'package:flutter/cupertino.dart';

class Encryption{

  static String encryptPassword({@required String passwordText}){

    return Crypt.sha256(passwordText, salt: "pawparent").toString();
  }

}

class StringUtils{

  static String toUpperCaseLower(String text){


    if (text != null && text.length == 1){
      return text.substring(0, 1).toUpperCase();
    }
    else if (text != null && text.length > 1){
      return text.substring(0, 1).toUpperCase() + text.toLowerCase().substring(1);
    }
    else{
      return text;
    }

  }

  static String toLowerCaseUpper(String text){
    if (text != null && text.length == 1){
      return text.substring(0, 1).toUpperCase();
    }
    else if (text != null && text.length > 1){
      return text.substring(0, 1).toLowerCase() + text.toUpperCase().substring(1);
    }
    else{
      return text;
    }

  }

  

  static String removeAllSpaces(String word){

    if (word == null){
      return "Null";
    }

    String trimmedWord = word.trim();
    String dummy = "";

    for (int i = 0; i < trimmedWord.length; ++i){
      if (trimmedWord[i] == " "  || trimmedWord[i] == "\t" || trimmedWord[i] == "\n" ){
        continue;
      }
      else{
        dummy = dummy + trimmedWord[i];
      }
    }

    return dummy;
  }





  static String cleanTextSpaces(String text){

    String spaceReplacement = " ";

    assert(spaceReplacement == " ");

    String cleanText = text.trim().replaceAll(r"\s+", spaceReplacement);

    return cleanText;
  }






  // FullPhoneNumber and phoneCode must be taken from firstore fields since they were validated
  static bool isValidPhoneNumberMatch({String fullPhoneNumber, String phoneCode, String fragmentPhoneNumber}){

    // full phone number comes in the format "+phonecodeandnumber".
    // phone code comes in the format "+phonecode"
    // Note that it is necessary for the above values to be trimmed

    String fullPhoneNum = fullPhoneNumber.trim();
    String fragmentPhoneNum = fragmentPhoneNumber.trim();

    const int minPhoneLength = 3;

    if (fragmentPhoneNum.length == 0)
      return false;

    if (fragmentPhoneNum[0] == phoneCode[0] && fullPhoneNum == fragmentPhoneNum){
      return true;
    }
    else if (fragmentPhoneNum.length >= minPhoneLength){

      if (fragmentPhoneNum.substring(0, minPhoneLength).length >= phoneCode.length - 1  &&
          fragmentPhoneNum.substring(0, minPhoneLength).contains(phoneCode.substring(1))){

        if (fullPhoneNum == phoneCode[0] + fragmentPhoneNum){
          return true;
        }
      }

      if (fullPhoneNum == phoneCode + fragmentPhoneNum){
        return true;
      }
    }

    return false;
  }



  static String formatNumber(int number){

    String numString = number.toString();

    double shrinkedNum = 0.0;

    if (number < 1000){
      return numString;
    }
    else if (number >= 1000 && number < 10000){
      return numString.substring(0, 1) + "," + numString.substring(1);
    }
    else if (number >= 10000 && number < 1000000){

      shrinkedNum = number / 1000.0;

      return shrinkedNum.toStringAsFixed(1) + "K";
    }
    else if (number >= 1000000 && number < 1000000000 ){
      shrinkedNum = number / 1000000.0;
      return shrinkedNum.toStringAsFixed(1) + "M";
    }
    else if (number >= 1000000000 && number < 1000000000000){
      shrinkedNum = number / 1000000000.0;
      return shrinkedNum.toStringAsFixed(1) + "B";
    }
    else if (number >= 1000000000000){
      shrinkedNum = number / 1000000000000;
      return shrinkedNum.toStringAsFixed(1) + "T";
    }
    else{
      return number.toString();
    }

  }


}



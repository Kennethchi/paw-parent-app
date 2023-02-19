import 'dart:async';

import 'package:paw_parent_app/utils/string_utils.dart';



mixin PostCommentsValidators{


  static StreamTransformer<String, String> textValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (text, sink){

        String cleanedText = StringUtils.cleanTextSpaces(text);

        if (cleanedText.length > 0){
          sink.add(cleanedText);
        }
        else{
          sink.addError("Comment needs CLeaning");
        }

      });

}




import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ServerApi{


  static Future<String> uploadFileToCloudStorage({@required File file, @required String filename, @required String storagePath})async{
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    StorageReference storageReference = firebaseStorage.ref().child(storagePath).child(filename);

    StorageTaskSnapshot storageTaskSnapshot = await storageReference.putFile(file).onComplete;

    return await storageTaskSnapshot.ref.getDownloadURL();
  }

}
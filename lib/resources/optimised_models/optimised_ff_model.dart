import 'package:meta/meta.dart';



class OptimisedFFModel implements Comparable<OptimisedFFModel>{

   String id;


   String name;
   String username;
   String user_id;
   String thumb;
   int t;

   OptimisedFFModel({
     this.name,
     this.username,
     @required this.user_id,
     this.thumb,
     @required this.t,
});


   OptimisedFFModel.fromJson(Map<dynamic, dynamic> json){

     this.name = json[FFFieldNamesOptimised.name];
     this.username = json[FFFieldNamesOptimised.username];
     this.user_id = json[FFFieldNamesOptimised.user_id];
     this.thumb = json[FFFieldNamesOptimised.thumb];
     this.t = json[FFFieldNamesOptimised.t];
   }


   Map<dynamic, dynamic> toJson(){

     Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();


     data[FFFieldNamesOptimised.name] = this.name;
     data[FFFieldNamesOptimised.username] = this.username;
     data[FFFieldNamesOptimised.user_id] = this.user_id;
     data[FFFieldNamesOptimised.thumb] = this.thumb;
     data[FFFieldNamesOptimised.t] = this.t;

     return data;
   }


   @override
   int compareTo(OptimisedFFModel other) {
     // TODO: implement compareTo


     // sorts in descending order
     if (this.id.compareTo(other.id) < 0){
       return 1;
     }
     else if (this.id.compareTo(other.id) > 0){
       return -1;
     }
     else{
       return 0;
     }
   }


   /*
  @override
  int compareTo(OptimisedFFModel other) {
    // TODO: implement compareTo


    // sorts in descending order
    if (this.t < other.t){
      return 1;
    }
    else if (this.t > other.t){
      return -1;
    }
    else{
      return 0;
    }
  }
  */

}

class FFFieldNamesOptimised {
  static const String name = "name";
  static const String username = "username";
  static const String user_id = "user_id";
  static const String thumb = "thumb";
  static const String t = "t";
}





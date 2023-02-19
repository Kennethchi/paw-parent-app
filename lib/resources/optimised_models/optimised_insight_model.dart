
class OptimisedInsightModel implements Comparable<OptimisedInsightModel>{

  String insightId;
  int numLikes;
  int numComments;
  int numShares;
  int numSeens;

  OptimisedInsightModel({
    this.insightId
  }){

    this.numLikes = 0;
    this.numComments = 0;
    this.numShares = 0;
    this.numSeens = 0;
  }

  OptimisedInsightModel.fromJson(Map<dynamic, dynamic> json){

    this.insightId = json[OptimisedInsightFieldNames.insight_id];
    this.numLikes = json[OptimisedInsightFieldNames.num_likes];
    this.numComments = json[OptimisedInsightFieldNames.num_comments];
    this.numShares = json[OptimisedInsightFieldNames.num_shares];
  }


  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data[OptimisedInsightFieldNames.insight_id] = this.insightId;
    data[OptimisedInsightFieldNames.num_likes] = this.numLikes;
    data[OptimisedInsightFieldNames.num_comments] = this.numComments;
    data[OptimisedInsightFieldNames.num_shares] = this.numShares;

    return data;
  }

  @override
  int compareTo(OptimisedInsightModel other) {


    /*
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
     */

    // enables sort in descending other
    if (this.insightId.compareTo(other.insightId) < 0){
      return 1;
    }
    else if(this.insightId.compareTo(other.insightId) > 0){
      return -1;
    }
    else{
      return 0;
    }


  }



}

class OptimisedInsightFieldNames {

  static const String insight_id = "insight_id";
  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";
  static const String num_seens = "num_seens";
}



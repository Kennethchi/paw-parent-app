



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_parent_app/features/post_comments/post_comments.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';

class DogPostRoomViewHandlers{

  static void showPostComments({@required BuildContext pageContext, @required DogPostModel dogPostModel}){

    showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){

          return Container(
            color: Colors.blueAccent,
            height: MediaQuery.of(context).size.height * 0.8,
            child: PostComments(dogPostModel: dogPostModel,),
          );

        }
    );


  }

}
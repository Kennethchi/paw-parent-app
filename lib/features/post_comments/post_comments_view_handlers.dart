


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_comment_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';

import 'post_comments_bloc.dart';
import 'post_comments_bloc_provider.dart';

class PostCommentsViewHandlers{



  // When the text in text field change. we set the current user istyping value based on whether the field is empty or not
  void onTextChange({@required BuildContext context, @required String text}){

    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = PostCommentsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    _bloc.addTextToStream(text: text);
  }




  Future<void> sendComment({@required BuildContext context, @required String cleanedComment}) async{

    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = PostCommentsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController textEditingController = _provider.textEditingController;


    // clears textfield
    textEditingController.clear();


    // adds null text to stream after text being sent
    _bloc.addTextToStream(text: null);

    UserModel currentUserModel = await _bloc.getUserModelData(userId: _bloc.getCurrentUserId);

    OptimisedCommentModel optimisedCommentModel = OptimisedCommentModel(
        user_id: currentUserModel.userId,
        comment: cleanedComment,
        t: Timestamp.now().millisecondsSinceEpoch
    );




    // dummy optimised comment model
    OptimisedCommentModel dummyOptimisedCommentsMoel = OptimisedCommentModel.fromJson(optimisedCommentModel.toJson());
    _bloc.getCommentsList.insert(0, dummyOptimisedCommentsMoel);
    dummyOptimisedCommentsMoel.username = currentUserModel.username;
    dummyOptimisedCommentsMoel.name = currentUserModel.profileName;
    dummyOptimisedCommentsMoel.thumb = currentUserModel.profileImageThumb;
    _bloc.addCommentListToStream(_bloc.getCommentsList);




    _bloc.addCommentData(
        optimisedCommentModel: optimisedCommentModel,
        postId: _bloc.getDogPostModel.postId,
        dogId: _bloc.getDogPostModel.dogUserId
    ).then((String commentId){

      int index = _bloc.getCommentsList.indexOf(dummyOptimisedCommentsMoel);
      _bloc.getCommentsList[index].id = commentId;
    });






    // reloads comments
    //_bloc.getCommentsData(postId: _bloc.getCommentsPostId, queryLimit: _bloc.getCommentsQueryLimit, endAtValue: null);


    // scrolls to top (since we are in reverse mode)
    _provider.scrollController.jumpTo(_provider.scrollController.position.minScrollExtent);
  }








  Future<void> showDeleteCommentActionDialog({@required BuildContext pageContext, @required OptimisedCommentModel optimisedCommentModel})async{

    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(pageContext);
    PostCommentsBloc bloc = PostCommentsBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenwidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Do you want to delete this Comment?"),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: ()async{


                  BasicUI.showProgressDialog(
                    pageContext: context,
                    child: Column(

                      children: <Widget>[

                        SpinKitFadingCircle(color: _themeData.primaryColor,),
                        SizedBox(height: screenHeight * scaleFactor * 0.25,),

                        Text("Deleting...", style: TextStyle(
                            color: _themeData.primaryColor,
                            fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                        ),)

                      ],
                    ),
                  );


                  bloc.deletePostComment(dogId: bloc.getDogPostModel.dogUserId, postId: bloc.getDogPostModel.postId, commentId: optimisedCommentModel.id).then((_){
                    bloc.getCommentsList.remove(optimisedCommentModel);
                    bloc.addCommentListToStream(bloc.getCommentsList);

                    Navigator.pop(context);
                    Navigator.pop(context);

                    BasicUI.showSnackBar(
                        context: pageContext,
                        message: "Comment has been deleted", textColor: _themeData.primaryColor,
                        duration: Duration(seconds: 2)
                    );
                  });

                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: (){

                  Navigator.pop(context);
                },
              ),

            ],


          );
        }
    );

  }


}
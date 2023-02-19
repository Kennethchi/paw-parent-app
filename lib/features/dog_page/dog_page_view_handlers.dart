



import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc_provider.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';

class DogPageViewHandlers{


  Future<void> deletePostModalDialog({BuildContext pageContext, @required DogPostModel dogPostModel}){

    DogPageBloc _bloc = DogPageBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenwidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


    showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Are you sure you want to delete this Post?"),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: ()async{

                  BasicUI.showProgressDialog(pageContext: context, child: Center(child: SpinKitFadingCircle(color: _themeData.primaryColor,),));

                  await _bloc.deleteDogPostData(dogUserId: _bloc.getDogModel.userId, ownerUserId: _bloc.getOwnerUserModel.userId, postId: dogPostModel.postId);

                  await _bloc.deleteOptimisedDogPost(dogUserId: _bloc.getDogModel.userId, ownerUserId: _bloc.getOwnerUserModel.userId, postId: dogPostModel.postId);

                  await _bloc.deleteAllPostLikes(postId: dogPostModel.postId, dogId: _bloc.getDogModel.userId);

                  _bloc.loadPosts(userId: _bloc.getOwnerUserModel.userId, dogId: _bloc.getDogModel.userId, dogQueryLimit: _bloc.getPostsQueryLimit);

                  Navigator.pop(context);
                  Navigator.pop(context);

                  BasicUI.showSnackBar(context: pageContext, message: "Post Deleted", textColor: _themeData.primaryColor);
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
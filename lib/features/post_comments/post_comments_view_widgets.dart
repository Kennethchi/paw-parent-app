import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_bloc.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_bloc_provider.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_comment_model.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as time_ago_provider;





class CommentsTitleWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = PostCommentsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return  Container(
      child: Center(
        child: Text("Comments",
          style: TextStyle(
              color: Colors.black,
              fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}






class CommentsTextFieldWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = PostCommentsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.only(bottom: 5.0),
      child: Card(
        color: Colors.black.withOpacity(0.075),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.white, width: 1.0)
        ),
        elevation: 0.0,

        child: TextField(
          onTap: null,
          //maxLength: 150,
          controller: _provider.textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(color: Colors.black),
          cursorColor: _themeData.primaryColor,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15.0),
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
              border: InputBorder.none,
              suffixIcon: SubmitButtonWidget(),
              hintText: "Comment here ...",
              counterStyle: TextStyle(color: Colors.black)

          ),
          onChanged: (String text){
            _provider.handlers.onTextChange(context: context, text: text);
          },


        ),






      ),
    );

  }
}






class SubmitButtonWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = PostCommentsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
      stream: _bloc.getTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

        return IconButton(
            color: _themeData.primaryColor,
            disabledColor: Colors.black.withOpacity(0.3),
            icon: Icon(FontAwesomeIcons.solidPaperPlane),

            onPressed: snapshot.hasData && snapshot.hasError == false? (){

              _provider.handlers.sendComment(context: context, cleanedComment: snapshot.data);
            }: null
        );

      },
    );
  }

}





class CommentModelViewHolder extends StatelessWidget{

  OptimisedCommentModel optimisedCommentModel;

  CommentModelViewHolder({@required this.optimisedCommentModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: GestureDetector(

        onTap: (){

          Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserModel: optimisedCommentModel.userModel)));
        },

        child: Container(
          child: optimisedCommentModel.thumb != null && optimisedCommentModel.thumb.isNotEmpty? CircleAvatar(
            radius: 20.0,
            backgroundColor: _themeData.primaryColor,
            backgroundImage: CachedNetworkImageProvider(optimisedCommentModel.thumb),
          ): CircleAvatar(
            radius: 20.0,
            backgroundColor: _themeData.primaryColor,
            child: Center(
              child: Text(optimisedCommentModel.name.characters.first.toUpperCase(), style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize
              ),),
            ),
          ),
        )
      ),
      trailing: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time_ago_provider.format(DateTime.fromMillisecondsSinceEpoch(optimisedCommentModel.t)),
              style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: Theme.of(context).textTheme.overline.fontSize
              ),
            ),
            StreamBuilder<String>(
              stream: _bloc.currentUserIdBehaviorSubject,
              builder: (context, snapshot) {

                if (snapshot.hasData && snapshot.data == optimisedCommentModel.user_id){
                  return GestureDetector(
                    onTap: (){

                      _provider.handlers.showDeleteCommentActionDialog(
                          pageContext: context,
                          optimisedCommentModel: optimisedCommentModel
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(Icons.more_vert, color: Colors.black,),
                    ),
                  );
                }
                else{
                  return Container();
                }

              }
            ),

          ],
        ),
      ),
      title: GestureDetector(
        onTap: (){

          Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserModel: optimisedCommentModel.userModel)));
        },

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Flexible(
              fit: FlexFit.loose,
              child: Text("@" + optimisedCommentModel.username,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

          ],
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * scaleFactor),
        child: Text(optimisedCommentModel.comment , style: TextStyle(color: Colors.black),),
      ),
      dense: true,
    );
  }
}





class CommentListWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build



    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<List<OptimisedCommentModel>>(
        stream: _bloc.getCommentListStream,
        builder: (BuildContext context, AsyncSnapshot<List<OptimisedCommentModel>> snapshot){

          switch(snapshot.connectionState){

            case ConnectionState.none: case ConnectionState.waiting:

            return SliverList(delegate: SliverChildListDelegate(

                <Widget>[
                  SpinKitChasingDots(color: _themeData.primaryColor,)
                ]

            ));

            case ConnectionState.active: case ConnectionState.done:

            if (snapshot.hasData){

              if (snapshot.data.length == 0){

                return SliverList(delegate: SliverChildListDelegate(

                    <Widget>[
                      Container()
                    ]

                ));
              }
              else{

                return SliverList(delegate: SliverChildListDelegate(

                    snapshot.data.map((OptimisedCommentModel optimisedCommentModel){

                      return StreamBuilder<String>(
                          stream: _bloc.currentUserIdBehaviorSubject,
                          builder: (context, snapshot) {

                            if (snapshot.hasData && snapshot.data == optimisedCommentModel.user_id){
                              return Dismissible(
                                  key: UniqueKey(),

                                  confirmDismiss: (DismissDirection direction)async{

                                    if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart){

                                      _provider.handlers.showDeleteCommentActionDialog(
                                          pageContext: context,
                                          optimisedCommentModel: optimisedCommentModel
                                      );
                                    }

                                    return false;
                                  },
                                  onDismissed: (DismissDirection direction){

                                  },

                                  child: CommentModelViewHolder(optimisedCommentModel: optimisedCommentModel)
                              );
                            }
                            else{
                              return CommentModelViewHolder(optimisedCommentModel: optimisedCommentModel);
                            }

                          }
                      );

                    }).toList()

                ));
              }


            }
            else{

              return SliverList(delegate: SliverChildListDelegate(

                  <Widget>[

                    ScaleAnimatedTextKit(
                      text: ["No", "Comments", "No Comments"],
                      alignment: Alignment.center,
                      duration: Duration(seconds: 2),
                      isRepeatingAnimation: false,
                      textStyle: TextStyle(
                          color: _themeData.primaryColor,
                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                      ),
                    )

                  ]

              ));

            }


          }


        }
    );
  }
}









class LoadingCommentsIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return SliverList(
      delegate: SliverChildListDelegate(
          <Widget>[

            Container(
                child: StreamBuilder(
                  stream: _bloc.getHasMoreCommentsStream,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.waiting:
                        return SpinKitChasingDots(color: _themeData.primaryColor,);
                      case ConnectionState.active: case ConnectionState.done:

                      if (snapshot.hasData && snapshot.data){
                        return SpinKitChasingDots(color: _themeData.primaryColor);
                      }
                      else{
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.5),
                          child: Center(
                            child: Text("No Comments",
                              style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize, color: _themeData.primaryColor),
                            ),
                          ),
                        );
                      }
                    }



                  },
                )
            )

          ]
      ),
    );


  }



}


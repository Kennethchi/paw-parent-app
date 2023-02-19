import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_chat_model.dart';
import 'chat_space_bloc.dart';
import 'chat_space_bloc_provider.dart';



class ChatMessageTextWidget extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatMessageTextWidget({@required this.optimisedChatModel});



  @override
  Widget build(BuildContext context) {


    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
        child: optimisedChatModel.chat_user_id == optimisedChatModel.sender_id?
        Text(
          optimisedChatModel.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: optimisedChatModel.seen == false? RGBColors.light_blue: DefaultTextStyle.of(context).style.color,
            fontWeight: optimisedChatModel.seen == false? FontWeight.w900: Theme.of(context).textTheme.body1.fontWeight,

          ),
        ):
        RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[

                  TextSpan(
                      text: "You:  ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
                  ),

                  TextSpan(text: optimisedChatModel.text)

                ]
            )
        )
    );

  }

}


class ChatMessageImageWidget extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatMessageImageWidget({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {

    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
        child: optimisedChatModel.chat_user_id == optimisedChatModel.sender_id?

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Icon(Icons.camera_alt,
              color: optimisedChatModel.seen == false? RGBColors.light_blue : Colors.black.withOpacity(0.4),
            ),
            SizedBox(width: screenWidth * scaleFactor * scaleFactor),

            Text("Image",
              style: TextStyle(
                  color: optimisedChatModel.seen == false? RGBColors.light_blue: Colors.black.withOpacity(0.4),
                  fontWeight: optimisedChatModel.seen == false? FontWeight.w900: Theme.of(context).textTheme.body1.fontWeight
              ),
            )

          ],
        ):


        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Text("You:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(width: screenWidth * scaleFactor * 0.25),


            Icon(Icons.camera_alt, color: Colors.black.withOpacity(0.4),),
            SizedBox(width: screenWidth * scaleFactor * scaleFactor),

            Text("Image")

          ],
        )
    );

  }

}




class ChatMessageAudioWidget extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatMessageAudioWidget({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {

    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
        child: optimisedChatModel.chat_user_id == optimisedChatModel.sender_id?

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Icon(FontAwesomeIcons.headphonesAlt,
              color: optimisedChatModel.seen == false? RGBColors.light_blue : Colors.black.withOpacity(0.4),
            ),
            SizedBox(width: screenWidth * scaleFactor * scaleFactor),

            Text("Audio",
              style: TextStyle(
                  color: optimisedChatModel.seen == false? RGBColors.light_blue: Colors.black.withOpacity(0.4),
                  fontWeight: optimisedChatModel.seen == false? FontWeight.w900: Theme.of(context).textTheme.body1.fontWeight
              ),
            )

          ],
        ):

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Text("You:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(width: screenWidth * scaleFactor * 0.25,),


            Icon(FontAwesomeIcons.headphonesAlt, color: Colors.black.withOpacity(0.4),),
            SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

            Text("Audio")

          ],
        )
    );

  }

}







class ChatMessageVideoWidget extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatMessageVideoWidget({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {

    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
        child: optimisedChatModel.chat_user_id == optimisedChatModel.sender_id?

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Icon(FontAwesomeIcons.video,
              color: optimisedChatModel.seen == false? RGBColors.light_blue : Colors.black.withOpacity(0.4),
            ),
            SizedBox(width: screenWidth * scaleFactor * 0.25),

            Text("Video",
              style: TextStyle(
                  color: optimisedChatModel.seen == false? RGBColors.light_blue: Colors.black.withOpacity(0.4),
                  fontWeight: optimisedChatModel.seen == false? FontWeight.w900: Theme.of(context).textTheme.body1.fontWeight
              ),
            )

          ],
        ):


        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Text("You:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(width: screenWidth * scaleFactor * 0.25,),


            Icon(FontAwesomeIcons.video, color: Colors.black.withOpacity(0.4),),
            SizedBox(width: screenWidth * scaleFactor * 0.25,),

            Text("Video")

          ],
        )
    );

  }

}





class ChatMessageSeenWidget extends StatelessWidget {

  OptimisedChatModel optimisedChatModel;

  ChatMessageSeenWidget({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {


    ChatSpaceBloc _bloc = ChatSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Event>(
        stream: _bloc.getChatSeenStreamEvent(
            currentUserId: _bloc.getCurrentUserId,
            chatUserId: optimisedChatModel.chat_user_id
        ),
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {

          switch(snapshot.connectionState){
            case ConnectionState.none:case ConnectionState.waiting:
            return SpinKitThreeBounce(color: _themeData.primaryContrastingColor, size: 12.0);
            case ConnectionState.active:case ConnectionState.done:

            if (snapshot.data.snapshot.value == false){
              return Icon(FontAwesomeIcons.check, color: Colors.black.withOpacity(0.4), size: 12.0,);
            }
            else if (snapshot.data.snapshot.value == true){
              return Icon(FontAwesomeIcons.checkDouble, color: _themeData.primaryColor, size: 12.0,);
            }
            else{
              return SpinKitThreeBounce(color: _themeData.primaryContrastingColor, size: 12.0);
            }
          }


        }
    );
  }
}







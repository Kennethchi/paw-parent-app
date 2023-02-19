


import 'package:flutter/material.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_chat_model.dart';

import 'chat_space_view_widgets.dart';

class ChatSpaceViewHandlers{



  Widget getChatMessageView({@required OptimisedChatModel optimisedChatModel}){

    switch(optimisedChatModel.msg_type){

      case MessageType.text:
        return ChatMessageTextWidget(optimisedChatModel: optimisedChatModel);
      case MessageType.image:
        return ChatMessageImageWidget(optimisedChatModel: optimisedChatModel);
      case MessageType.audio:
        return ChatMessageAudioWidget(optimisedChatModel: optimisedChatModel);
      case MessageType.video:
        return ChatMessageVideoWidget(optimisedChatModel: optimisedChatModel);
      default:
        return Container();
    }
  }


}


class GenderType{
  static const String male = "male";
  static const String female = "female";
  static const String other = "other";
}

const List<String> get_dog_gender_types = [
  GenderType.male,
  GenderType.female
];



class UserType{
  static const String pet_owner = "pet_owner";
  static const String adoption_center = "adoption_center";
}



class ImageResolutionOption{
  static const double maxWidth = 1080;
  static const double maxHeight = 1080;
  static const int maxQuality = 100;

  static const double mediumWidth = 720;
  static const double mediumHeight = 720;
  static const int mediumQuality = 80;
}

class FileExtensions{
  static const String jpg = ".jpg";
  static const String mp3= ".mp3";
  static const String mp4 = ".mp4";
}



class DogInfoMenuType{
  static const String about = "about";
  static const String details = "details";
}



class DogPostType{

  static const String image = "image";
  static const String video = "video";
  static const String audio = "audio";
  static const String google_ads = "google_ads";
}

class InsightType{

  static const String image = "image";
  static const String video = "video";
  static const String audio = "audio";
  static const String google_ads = "google_ads";
}



class AppDataLimits{
  static const int numberOfImagesPerPost =  5;
  static const int maxLinesForPostText = 4;
  static const int maxNumberOfMessagesToLoad = 500;
}

enum DOG_POST_MENU_TYPE{
  DELETE_POST
}

enum REPOSITORY_DEPENDENCY{
  PRODUCTION,
  MOCK
}


class AppConstants{

  static const String android_app_link = "https://play.google.com/store/apps/details?id=com.pawparent.app";
}


enum DOG_POST_QUERY_TYPE{
  FEVORITES,
  FOLLOWING,
  TRENDING
}


enum SEARCH_TYPE{
  USER_USERNAME,
  USER_PROFILENAME,
  DOG_USERNAME,
  DOG_PROFILENAME
}


class MessageState{
  //static const String pending = "pending";
  static const String sent = "sent";
  static const String received = "received";
  static const String seen = "seen";
}



class MessageType{

  static const String text = "text";
  static const String image = "image";
  static const String video = "video";
  static const String audio = "audio";
}





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paw_parent_app/features/dog_schedule_page/dog_schedule_page.dart';
import 'package:paw_parent_app/features/home/home.dart';
import 'package:paw_parent_app/features/splash_screen/splash_screen.dart';
import 'package:paw_parent_app/ui/google_ads_widget/google_ads_widget.dart';

import 'constants/constants.dart';



void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return CupertinoApp(
      title: 'Paw Parent',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: CupertinoThemeData(

        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily
          ),
          //primaryColor: Color.fromRGBO(24, 171, 187, 1.0)
          primaryColor: Color.fromRGBO(252, 148, 113, 1.0)

        ),
        //primaryColor: Color.fromRGBO(24, 171, 187, 1.0),
          primaryColor: Color.fromRGBO(252, 148, 113, 1.0),

          primaryContrastingColor: Color.fromRGBO(221, 251, 169, 1.0)
      ),

      home: Home(),
    );
  }
}

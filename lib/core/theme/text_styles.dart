import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const textTheme = TextTheme(
    displayLarge: heading,
    bodyLarge: body,
    // Define other text styles here
  );

  // Dark theme text styles
  static const TextStyle headingDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static const textThemeDark = TextTheme(
    displayLarge: headingDark,
    bodyLarge: bodyDark,
    // Define other text styles here
  );
}

class ThemeConstands {
  static const List<String> fontFamilyFallback = ['KantumruyPro'];      
  static const  font10Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 10.0
  );
  static const  font10SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 14.0
  );

  static const  font12Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 12.0
  );
  static const  font12SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 12.0
  );


  static const  font14Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 14.0
  );
  static const  font14SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 14.0
  );


  static const  font16Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 16.0
  );
  static const  font16SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 16.0
  );


  static const  font18Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 18.0
  );
  static const  font18SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 18.0
  );

  static const  font20Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 20.0
  );
  static const  font20SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 20.0
  );

  static const  font22Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 22.0
  );
  static const  font22SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 22.0
  );

  static const  font24Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 24.0
  );
  static const  font24SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 24.0
  );

  static const  font28Regular =  TextStyle(
    fontFamily: "KantumruyPro-Regular",
    fontSize: 28.0
  );
  static const  font28SemiBold =  TextStyle(
    fontFamily: "KantumruyPro-SemiBold",
    fontSize: 28.0
  );
}

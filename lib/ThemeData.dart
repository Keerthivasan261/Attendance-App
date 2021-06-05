import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context){
  return ThemeData(
    appBarTheme: AppBarTheme(color: Colors.transparent,elevation: 0),
    primaryColor: Colors.deepOrange[400],
    accentColor: Colors.grey[600],
    scaffoldBackgroundColor: Colors.grey[200],
    colorScheme: ColorScheme.light(
      secondary: Color(0xFFE4E9F2),
    ),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    accentIconTheme: IconThemeData(color: Colors.grey[900]),
    primaryIconTheme: IconThemeData(color: Colors.grey[900]),
  );
}

ThemeData darkTheme(BuildContext context){
  return ThemeData(
    appBarTheme: AppBarTheme(color: Colors.transparent,elevation: 0,),
    primaryColor: Color(0xFF1FE0B9),
    accentColor: Colors.grey[500],
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.light(
      secondary: Color(0xFFE4E9F2),
    ),
    backgroundColor: Color(0xFF323232),
    iconTheme: IconThemeData(color: Colors.grey[800]),
    accentIconTheme: IconThemeData(color: Colors.grey[100]),
    primaryIconTheme: IconThemeData(color: Colors.grey[200]),
  );
}
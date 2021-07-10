import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get darktheme {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.purple[200],
        focusColor: Colors.indigoAccent,
        fontFamily: 'Georgia',
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.indigoAccent, cursorColor: Colors.indigoAccent, selectionColor: Colors.indigoAccent),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
        ),
        
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.purple[300],
        ));
  }

  static ThemeData get lighttheme {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.purple[200],
        focusColor: Colors.indigoAccent,
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.indigoAccent, cursorColor: Colors.indigoAccent, selectionColor: Colors.indigoAccent),
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.purple[300],
        ));
  }
}
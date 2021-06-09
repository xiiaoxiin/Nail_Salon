import 'package:flutter/material.dart';

import 'model/themes.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lighttheme,
      title: 'Nail Salon', 
      home: SplashScreen());
  }
}

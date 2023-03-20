import 'package:flutter/material.dart';
import 'package:weather_app/home_screen.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScren(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white)
      ),
    );
  }
}

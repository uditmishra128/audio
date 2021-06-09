import 'package:audioimage/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioImageApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            centerTitle: true,
            brightness: Brightness.light,
            elevation: 2,
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black54),
            textTheme: TextTheme(
              headline1: TextStyle(
                  color: Color.fromRGBO(167, 124, 96, 1.0),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 12),
            )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

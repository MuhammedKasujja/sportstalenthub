import 'package:flutter/material.dart';
import 'package:sth/pages/splash.dart';
import 'package:sth/utils/consts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Consts.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      //home: StartPage(),
      home: const SplashPage(),
    );
  }
}
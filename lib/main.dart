
import 'package:eng_story/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'screens/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());

}



class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'English Story',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),

    );
  }
}

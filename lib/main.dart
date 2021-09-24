import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'main_page.dart';
import 'guide_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor primary_materialcolor = MaterialColor(
    CtTheme.CtHexColor.primary,
    <int, Color>{
      50: Color(CtTheme.CtHexColor.primary),
      100: Color(CtTheme.CtHexColor.primary),
      200: Color(CtTheme.CtHexColor.primary),
      300: Color(CtTheme.CtHexColor.primary),
      400: Color(CtTheme.CtHexColor.primary),
      500: Color(CtTheme.CtHexColor.primary),
      600: Color(CtTheme.CtHexColor.primary),
      700: Color(CtTheme.CtHexColor.primary),
      800: Color(CtTheme.CtHexColor.primary),
      900: Color(CtTheme.CtHexColor.primary),
    }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primary_materialcolor,
      ),
      home: ReadyPage(),
    );
  }
}

class ReadyPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: prefs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          tiny_db = snapshot.data;

          if(tiny_db.getString("user_email") == null){
            return GuidePage();
          }
          else{
            checkUserPoint();
            return MainPage();
          }
        }
        else if(snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "앱을 다시 실행시켜주세요",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        }
        else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }

  void checkUserPoint() async{
    await firestoreInstance.collection("users").doc(tiny_db.getString("user_email")).get().then(
            (value) {
              tiny_db.setInt("user_point", value["point"]);
            }
    );
  }
}
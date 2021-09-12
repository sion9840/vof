import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vof/main_page.dart';
import 'guide_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      home: ReadyPage(),
    );
  }
}

class ReadyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data!.getBool("is_first") == null){
            return GuidePage();
          }
          else{
            return GuidePage();
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
}
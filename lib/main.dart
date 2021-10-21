import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vof/_.dart';

import 'guide_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor primary_material_color = MaterialColor(
    CtTheme.HexColor.Primary2,
    <int, Color>{
      50: Color(CtTheme.HexColor.Primary2),
      100: Color(CtTheme.HexColor.Primary2),
      200: Color(CtTheme.HexColor.Primary2),
      300: Color(CtTheme.HexColor.Primary2),
      400: Color(CtTheme.HexColor.Primary2),
      500: Color(CtTheme.HexColor.Primary2),
      600: Color(CtTheme.HexColor.Primary2),
      700: Color(CtTheme.HexColor.Primary2),
      800: Color(CtTheme.HexColor.Primary2),
      900: Color(CtTheme.HexColor.Primary2),
    }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primary_material_color,
      ),
      home: ReadyPage(),
    );
  }
}

class ReadyPage extends StatelessWidget {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: prefs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          ClientDbInstance = snapshot.data;

          if(ClientDbInstance.getString("user_id") == null){ // 만약 앱을 처음 사용한다면
            return GuidePage();
          }
          else{
            return GuidePage();
            //initSet();
            //return MainPage();
          }
        }
        else if(snapshot.hasError) {
          return Scaffold(
            backgroundColor: Color(CtTheme.HexColor.Background),
            body: Center(
              child: CtTheme.Icon.Error(
                Color(CtTheme.HexColor.Black),
                CtTheme.IconSize.Middle,
              ),
            ),
          );
        }
        else{
          return Scaffold(
            backgroundColor: Color(CtTheme.HexColor.Background),
            body: Center(
              child: CtTheme.Icon.Loading(
                Color(CtTheme.HexColor.Black),
              ),
            ),
          );
        }
      }
    );
  }

  /*
  void initSet() async{
    // 만약 앱을 로그아웃 혹은 계정 삭제를 안하고 삭제한 경우 DB에 저장 되어있는 사용자 정보를 이용하여 자동 파이어베이스 어스 로그인
    if (await FirebaseAuth.instance.currentUser! == null) {
      String _db_user_password = "";

      await FirestoreInstance.collection("users")
        .doc(ClientDbInstance.getString("user_id"))
        .get().then(
          (value){
            _db_user_password = value["password"];
          }
      );

      UserCredential _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: tiny_db.getString("user_email"),
          password: _db_user_password
      );
    }

    // 포인트 새로고침
    await firestoreInstance.collection("users").doc(tiny_db.getString("user_email")).get().then(
            (value) {
              tiny_db.setInt("user_point", value["point"]);
            }
    );
  }
   */
}
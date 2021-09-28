import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'custom_theme.dart';
import 'custom_theme.dart';
import 'custom_theme.dart';
import 'custom_theme.dart';
import 'custom_theme.dart';
import 'main_page.dart';

class LoginPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_email = "";
  String input_user_password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CtTheme.CtPaddingSize.general),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "로그인",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.too_big,
                ),
              ),
              SizedBox(height: 30.0,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이메일",
                ),
                onChanged: (value) {
                  input_user_email = value;
                },
              ),
              SizedBox(height: 10.0,),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "비밀번호(6~16자)",
                ),
                onChanged: (value) {
                  input_user_password = value;
                },
              ),
              SizedBox(height: 30.0,),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async{
                    EasyLoading.show(status: '로딩중...');

                    if((6 > input_user_password.length) || (16 < input_user_password.length)) {
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                                "비밀번호는 6~16자여야 합니다",
                              style: TextStyle(
                                fontSize: CtTheme.CtTextSize.general,
                                color: Colors.black,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text(
                                    "확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.CtTextSize.general,
                                    color: Color(CtTheme.CtHexColor.primary),
                                  ),
                                ),
                              ),
                            ],
                          )
                      );
                    }
                    else if(true){
                      bool _is_error = false;

                      try {
                        UserCredential _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: input_user_email,
                            password: input_user_password
                        );
                      } on FirebaseAuthException catch (e) {
                        _is_error = true;

                        print(e);

                        if (e.code == 'user-not-found') {
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("존재하지 않는 이메일입니다",
                                  style: TextStyle(
                                    fontSize: CtTheme.CtTextSize.general,
                                    color: Colors.black,
                                  ),),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, "확인"),
                                    child: Text("확인",
                                      style: TextStyle(
                                        fontSize: CtTheme.CtTextSize.general,
                                        color: Color(CtTheme.CtHexColor.primary),
                                      ),),
                                  ),
                                ],
                              )
                          );
                        } else if (e.code == 'wrong-password') {
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("비밀번호가 맞지 않습니다",
                                  style: TextStyle(
                                    fontSize: CtTheme.CtTextSize.general,
                                    color: Colors.black,
                                  ),),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, "확인"),
                                    child: Text("확인",
                                      style: TextStyle(
                                        fontSize: CtTheme.CtTextSize.general,
                                        color: Color(CtTheme.CtHexColor.primary),
                                      ),),
                                  ),
                                ],
                              )
                          );
                        } else if (e.code == 'invalid-email'){
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    content: Text("이메일의 형식이 맞지 않습니다",
                                      style: TextStyle(
                                        fontSize: CtTheme.CtTextSize.general,
                                        color: Colors.black,
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "확인"),
                                        child: Text("확인",
                                          style: TextStyle(
                                            fontSize: CtTheme.CtTextSize.general,
                                            color: Color(CtTheme.CtHexColor.primary),
                                          ),),
                                      ),
                                    ],
                                  )
                          );
                        }
                        else{
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    content: Text("로그인에 실패하셨습니다",
                                      style: TextStyle(
                                        fontSize: CtTheme.CtTextSize.general,
                                        color: Colors.black,
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "확인"),
                                        child: Text("확인",
                                          style: TextStyle(
                                            fontSize: CtTheme.CtTextSize.general,
                                            color: Color(CtTheme.CtHexColor.primary),
                                          ),),
                                      ),
                                    ],
                                  )
                          );
                        }
                      }

                      if(_is_error == false){
                        String _db_user_name = "";
                        String _db_user_type = "";
                        String _db_user_password = "";
                        String _db_user_church_id = "";
                        int _db_user_point = 0;

                        await firestoreInstance.collection("users").doc(input_user_email).get().then(
                                (value) {
                              _db_user_name = value["name"];
                              _db_user_type = value["type"];
                              _db_user_church_id = value["church_id"];
                              _db_user_point = value["point"];
                            }
                        );

                        tiny_db.setString("user_name", _db_user_name);
                        tiny_db.setString("user_type", _db_user_type);
                        tiny_db.setString("user_email", input_user_email);
                        tiny_db.setString("user_church_id", _db_user_church_id);
                        tiny_db.setInt("user_point", _db_user_point);

                        EasyLoading.dismiss();

                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            MainPage()), (Route<dynamic> route) => false);
                      }
                    }
                  },
                  child: Text(
                    "로그인",
                    style: TextStyle(
                      fontSize: CtTheme.CtTextSize.general,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.CtHexColor.primary)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
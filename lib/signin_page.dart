import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'main_page.dart';

class SigninPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_name = "";
  String input_user_email = "";
  String input_user_password = "";
  String input_user_passwordcheck = "";
  String input_user_type = "";

  String display_user_type = "학생";

  SigninPage(String _type){
    input_user_type = _type;

    if(input_user_type == "t"){
      display_user_type = "교사";
    }
  }

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
                "${display_user_type} 회원가입",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.too_big,
                ),
              ),
              SizedBox(height: 30.0,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이름(ex:홍길동, 1~10자)",
                ),
                onChanged: (value) {
                  input_user_name = value;
                },
              ),
              SizedBox(height: 10.0,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이메일(.com으로 끝나는 이메일만 가능합니다)",
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
              SizedBox(height: 10.0,),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "비밀번호 확인",
                ),
                onChanged: (value) {
                  input_user_passwordcheck = value;
                },
              ),
              SizedBox(height: 30.0,),
              InkWell(
                onTap: () async{
                  if((1 > input_user_name.length) || (10 < input_user_name.length)) {
                    showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("이름은 1~10자여야 합니다"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, "확인"),
                              child: const Text("확인"),
                            ),
                          ],
                        )
                    );
                  }
                  else if((6 > input_user_password.length) || (16 < input_user_password.length)) {
                    showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("비밀번호는 6~16자여야 합니다"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, "확인"),
                              child: const Text("확인"),
                            ),
                          ],
                        )
                    );
                  }
                  else if(input_user_password != input_user_passwordcheck){
                    showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("비밀번호가 일치하지 않습니다"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, "확인"),
                              child: const Text("확인"),
                            ),
                          ],
                        )
                    );
                  }
                  else if(input_user_email.contains(".com") == false){
                    showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text(".com으로 끝나는 이메일만 가능합니다"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, "확인"),
                              child: const Text("확인"),
                            ),
                          ],
                        )
                    );
                  }
                  else if(true){
                    bool _is_error = false;

                    try {
                      UserCredential _userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: input_user_email,
                          password: input_user_password
                      );
                    } on FirebaseAuthException catch (e) {
                      _is_error = true;

                      print(e);

                      if (e.code == 'weak-password') {
                        showDialog<String>(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  content: const Text(
                                      "보안이 약한 비밀번호입니다\n비밀번호를 바꿔주세요"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, "확인"),
                                      child: const Text("확인"),
                                    ),
                                  ],
                                )
                        );
                      } else if (e.code == 'email-already-in-use') {
                        showDialog<String>(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  content: const Text("이미 존재하는 이메일입니다"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, "확인"),
                                      child: const Text("확인"),
                                    ),
                                  ],
                                )
                        );
                      } else if (e.code == 'invalid-email'){
                        showDialog<String>(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  content: const Text("이메일의 형식이 맞지 않습니다"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, "확인"),
                                      child: const Text("확인"),
                                    ),
                                  ],
                                )
                        );
                      }
                      else{
                        showDialog<String>(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  content: const Text("회원가입에 실패하셨습니다"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, "확인"),
                                      child: const Text("확인"),
                                    ),
                                  ],
                                )
                        );
                      }
                    }

                    if(_is_error == false){
                      await firestoreInstance
                          .collection("users")
                          .doc(input_user_email)
                          .set(
                          {
                            "name" : input_user_name,
                            "type" : input_user_type,
                            "email" : input_user_email,
                            "password" : input_user_password,
                            "church_id" : "",
                            "qt_completion_dates" : [],
                            "worship_completion_dates" : [],
                            "point" : 0,
                          });

                      tiny_db.setString("user_name", input_user_name);
                      tiny_db.setString("user_type", input_user_type);
                      tiny_db.setString("user_email", input_user_email);
                      tiny_db.setString("user_church_id", "");
                      tiny_db.setInt("user_point", 0);

                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          MainPage()), (Route<dynamic> route) => false);
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                    color: Color(CtTheme.CtHexColor.primary),
                  ),
                  child: Center(
                    child: Text(
                      "회원가입",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: CtTheme.CtTextSize.general,
                      ),
                    ),
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
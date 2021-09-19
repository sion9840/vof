import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vof/global_variable.dart';

import 'main_page.dart';

class LoginPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_email = "";
  String input_user_password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이메일",
                ),
                onChanged: (value) {
                  input_user_email = value;
                },
              ),
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async{
                    if((6 > input_user_password.length) || (16 < input_user_password.length)) {
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
                          showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const Text("존재하지 않는 이메일입니다"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, "확인"),
                                    child: const Text("확인"),
                                  ),
                                ],
                              )
                          );
                        } else if (e.code == 'wrong-password') {
                          showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const Text("비밀번호가 맞지 않습니다"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, "확인"),
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
                                    content: const Text("로그인에 실패하셨습니다"),
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      }
                    }
                  },
                  child: Text("확인"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
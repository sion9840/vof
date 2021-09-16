import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vof/global_variable.dart';

import 'main_page.dart';

class SigninPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_name = "";
  String input_user_id = "";
  String input_user_password = "";
  String input_user_passwordcheck = "";
  String input_user_email = "";
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
      appBar: AppBar(
        title: Text("${display_user_type} 회원가입"),
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
                  labelText: "이름(ex:홍길동, 1~10자)",
                ),
                onChanged: (value) {
                  input_user_name = value;
                },
              ),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "아이디(6~16자)",
                ),
                onChanged: (value) {
                  input_user_id = value;
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
              SizedBox(height: 10,),
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
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async{
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
                    else if((6 > input_user_id.length) || (16 < input_user_id.length)) {
                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text("아이디는 6~16자여야 합니다"),
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
                    else if(true){
                      bool _is_same_id = false;
                      await firestoreInstance.collection("users").get().then((querySnapshot) {
                        querySnapshot.docs.forEach((result) {
                          var _data = result.data();

                          if(input_user_id == _data["id"]){
                            _is_same_id = true;
                            return;
                          }
                        });
                      });

                      if(_is_same_id == true){
                        showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text("이미 존재하는 아이디입니다"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, "확인"),
                                  child: const Text("확인"),
                                ),
                              ],
                            )
                        );
                      }
                      else{
                        bool _is_valid = EmailValidator.validate(input_user_email);

                        if(_is_valid == false){
                          showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const Text("존재하지 않는 이메일 입니다"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, "확인"),
                                    child: const Text("확인"),
                                  ),
                                ],
                              )
                          );
                        }
                        else{
                          bool _is_same_email = false;

                          await firestoreInstance.collection("users").get().then((querySnapshot) {
                            querySnapshot.docs.forEach((result) {
                              var _data = result.data();

                              if(input_user_email == _data["email"]){
                                _is_same_email = true;
                                return;
                              }
                            });
                          });

                          if(_is_same_email){
                            showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text("이미 존재하는 이메일 입니다\n다른 이메일을 사용해주세요"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, "확인"),
                                      child: const Text("확인"),
                                    ),
                                  ],
                                )
                            );
                          }
                          else{
                            showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("재확인"),
                                  content: Row(
                                    children: <Widget>[
                                      Text("사용자 이름이 "),
                                      Text(input_user_name, style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("이 맞습니까?"),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        await firestoreInstance
                                            .collection("users")
                                            .doc(input_user_id)
                                            .set(
                                            {
                                              "name" : input_user_name,
                                              "type" : input_user_type,
                                              "id" : input_user_id,
                                              "password" : input_user_password,
                                              "church_id" : "",
                                              "email" : input_user_email,
                                            });

                                        tiny_db.setStringList("user", [
                                          input_user_id,
                                          input_user_name,
                                          input_user_type,
                                          "",
                                        ]
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MainPage()),
                                        );
                                      },
                                      child: const Text("네"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, "아니요"),
                                      child: const Text("아니요"),
                                    ),
                                  ],
                                )
                            );
                          }
                        }
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
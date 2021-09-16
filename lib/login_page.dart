import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vof/global_variable.dart';

import 'main_page.dart';

class LoginPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_id = "";
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
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async{
                    if((6 > input_user_id.length) || (16 < input_user_id.length)) {
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
                    else if(true){
                      bool _is_same_id = false;
                      String _db_user_password = "";

                      String _db_user_id = "";
                      String _db_user_name = "";
                      String _db_user_type = "";
                      String _db_user_church_id = "";

                      await firestoreInstance.collection("users").get().then((querySnapshot) {
                        querySnapshot.docs.forEach((result) {
                          var _data = result.data();

                          if(_data["id"] == input_user_id){
                            _is_same_id = true;
                            _db_user_password = _data["password"];

                            _db_user_id = _data["id"];
                            _db_user_name = _data["name"];
                            _db_user_type = _data["type"];
                            _db_user_church_id = _data["church_id"];

                            return;
                          }
                        });
                      });

                      if(_is_same_id == true){
                        if(input_user_password == _db_user_password){
                          tiny_db.setStringList("user", [
                            _db_user_id,
                            _db_user_name,
                            _db_user_type,
                            _db_user_church_id,
                          ]
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        }
                        else{
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
                        }
                      }
                      else{
                        showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text("존재하지 않는 아이디입니다"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, "확인"),
                                  child: const Text("확인"),
                                ),
                              ],
                            )
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
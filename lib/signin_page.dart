import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_page.dart';

class SigninPage extends StatelessWidget {
  String _user_type = "";
  SigninPage(String type){
    _user_type = type;
  }

  @override
  Widget build(BuildContext context) {
    final _firestoreInstance = FirebaseFirestore.instance;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    String _user_name = "";
    String _user_id = "";
    String _user_password = "";
    String _user_passwordcheck = "";

    String _display_user_type = "학생";
    if(_user_type == "t"){
      _display_user_type = "교사";
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("${_display_user_type} 회원가입"),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: _prefs,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Padding(
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
                      _user_name = value;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "아이디(6~16자)",
                    ),
                    onChanged: (value) {
                      _user_id = value;
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
                      _user_password = value;
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
                      _user_passwordcheck = value;
                    },
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () async{
                        if((1 > _user_name.length) || (10 < _user_name.length)) {
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
                        else if((6 > _user_id.length) || (16 < _user_id.length)) {
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
                        else if((6 > _user_password.length) || (16 < _user_password.length)) {
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
                        else if(_user_password != _user_passwordcheck){
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
                          bool _is_same = false;
                          await _firestoreInstance.collection("users").get().then((querySnapshot) {
                            querySnapshot.docs.forEach((result) {
                              var _data = result.data();

                              if(_data["id"] == _user_id){
                                _is_same = true;
                                return;
                              }
                            });
                          });

                          if(_is_same == true){
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
                            showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("재확인"),
                                  content: Row(
                                    children: <Widget>[
                                      Text("사용자 이름이 "),
                                      Text(_user_name, style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("이 맞습니까?"),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, "아니요"),
                                      child: const Text("아니요"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await _firestoreInstance
                                            .collection("users")
                                            .doc(_user_id)
                                            .set(
                                            {
                                              "name" : _user_name,
                                              "type" : _user_type,
                                              "id" : _user_id,
                                              "password" : _user_password,
                                              "church_id" : "",
                                            });

                                        snapshot.data!.setStringList("user", [
                                          _user_name,
                                          _user_id,
                                          _user_password,
                                          _user_type,
                                          ""]
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MainPage()),
                                        );
                                      },
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
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: Text(
                "뒤로 이동해주세요",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}
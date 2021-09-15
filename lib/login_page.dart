import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _firestoreInstance = FirebaseFirestore.instance;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    String _user_id = "";
    String _user_password = "";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("로그인"),
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
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async{
                          if((6 > _user_id.length) || (16 < _user_id.length)) {
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
                          else if(true){
                            bool _is_same = false;
                            String _user_real_name = "";
                            String _user_real_password = "";
                            String _user_real_type = "";
                            String _user_real_church_id = "";

                            await _firestoreInstance.collection("users").get().then((querySnapshot) {
                              querySnapshot.docs.forEach((result) {
                                var _data = result.data();

                                if(_data["id"] == _user_id){
                                  _is_same = true;
                                  _user_real_name = _data["name"];
                                  _user_real_password = _data["password"];
                                  _user_real_type = _data["type"];
                                  _user_real_church_id = _data["church_id"];
                                  return;
                                }
                              });
                            });

                            if(_is_same == true){
                              if(_user_password == _user_real_password){
                                snapshot.data!.setStringList("user", [
                                  _user_real_name,
                                  _user_id,
                                  _user_real_password,
                                  _user_real_type,
                                  _user_real_church_id]
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
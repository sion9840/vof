import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_page.dart';

class StudentSignin2Page extends StatelessWidget {
  String _church_id = "";
  StudentSignin2Page(church_id){
    _church_id = church_id;
  }

  @override
  Widget build(BuildContext context) {
    final _firestoreInstance = FirebaseFirestore.instance;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var _uuid = Uuid();

    String _student_name = "";
    String _student_id = "";
    String _student_password = "";
    String _student_passwordcheck = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
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
                      _student_name = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "아이디(6~16자)",
                    ),
                    onChanged: (value) {
                      _student_id = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "비밀번호(6~16자)",
                    ),
                    onChanged: (value) {
                      _student_password = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "비밀번호 확인",
                    ),
                    onChanged: (value) {
                      _student_passwordcheck = value;
                    },
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        if((1 > _student_name.length) || (10 < _student_name.length)) {
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
                        else if((6 > _student_id.length) || (16 < _student_id.length)) {
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
                        else if((6 > _student_password.length) || (16 < _student_password.length)) {
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
                        else if(_student_password != _student_passwordcheck){
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
                          _firestoreInstance.collection("users").get().then((querySnapshot) {
                            querySnapshot.docs.forEach((result) {
                              var _data = result.data();

                              if(_data["id"] == _student_id){
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
                                      Text("학생 이름이 "),
                                      Text(_student_name, style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("이 맞습니까?"),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, "아니요"),
                                      child: const Text("아니요"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _firestoreInstance
                                            .collection("users")
                                            .doc(_student_id)
                                            .set(
                                            {
                                              "id" : _student_id,
                                              "name" : _student_name,
                                              "password" : _student_password,
                                              "church_id" : _church_id,
                                            });

                                        List _church_students = [];
                                        _firestoreInstance
                                            .collection("churches")
                                            .doc(_church_id)
                                            .get()
                                            .then(
                                              (value) {
                                                _church_students = value.get("students");
                                              }
                                            );

                                        _firestoreInstance
                                            .collection("churches")
                                            .doc(_church_id)
                                            .update({"students": _church_students + [_student_id]});

                                        snapshot.data!.setBool("is_first", true);
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

/*

*/
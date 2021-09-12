import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'main_page.dart';

class Signin2Page extends StatelessWidget {
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
        title: Text("회원가입 > 교회 찾기 > 학생 정보 입력"),
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
                      labelText: "이름(ex:홍길동, 5~10자)",
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
                        if((5 > _student_name.length) || (5 < _student_name.length))
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
showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("재확인"),
                              content: Row(
                                children: <Widget>[
                                  Text("학생 이름이 "),
                                  Text(student_name, style: TextStyle(fontWeight: FontWeight.bold)),
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
                                    String _student_id = uuid.v1();
                                    firestoreInstance.collection("sDB984").doc(_student_id).set(
                                        {
                                          "id" : _student_id,
                                          "name" : student_name,
                                        });
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
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vof/att_qrimage_page.dart';
import 'package:vof/global_variable.dart';

import 'att_qrimage_scanner_page.dart';
import 'guide_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_church_id = "";

  String input_user_password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vof 포인트"),
      ),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Text(
                "안녕하세요\n${tiny_db.getString("user_name")}님\n\n현재 ${tiny_db.getInt("user_point")}포인트를 가지고 계십니다",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async{
                    int _db_user_point = 0;

                    await firestoreInstance
                        .collection("users")
                        .doc(tiny_db.getString("user_email"))
                        .get().then(
                            (value){
                          _db_user_point = value["point"];
                        }
                    );

                    tiny_db.setInt("user_point", _db_user_point);

                    setState(() {});

                    showDialog<String>(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              content: const Text("포인트가 새로고침 되었습니다"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, "확인"),
                                  child: const Text("확인"),
                                ),
                              ],
                            )
                    );
                  },
                  child: Text("포인트 새로고침"),
                ),
              ),
              SizedBox(height: 20,),
              Spacer(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("로그아웃"),
                onTap: (){
                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text("로그아웃 하시겠습니까?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async{
                              await FirebaseAuth.instance.signOut();

                              tiny_db.remove("user_name");
                              tiny_db.remove("user_type");
                              tiny_db.remove("user_email");
                              tiny_db.remove("user_church_id");
                              tiny_db.remove("user_point");

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GuidePage()),
                              );
                            },
                            child: const Text("예"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, "아니요"),
                            child: const Text("아니요"),
                          ),
                        ],
                      )
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text("계정 삭제"),
                onTap: (){
                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text("계정을 삭제하시겠습니까?\n(경고 : 다시 계정을 되돌릴 수 없습니다)"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async{
                              await FirebaseAuth.instance.currentUser!.delete();

                              await firestoreInstance
                                  .collection("users")
                                  .doc(tiny_db.getString("user_email"))
                                  .delete();

                              if(tiny_db.getString("user_church_id") != ""){
                                List<String> _students = [];

                                await firestoreInstance
                                    .collection("churches")
                                    .doc(tiny_db.getString("user_church_id"))
                                    .get().then(
                                        (value){
                                      _students = value["students"].cast<String>();
                                    }
                                );

                                _students.remove(tiny_db.getString("user_email"));

                                await firestoreInstance
                                    .collection("churches")
                                    .doc(tiny_db.getString("user_church_id"))
                                    .update(
                                    {
                                      "students" : _students
                                    }
                                );
                              }

                              tiny_db.remove("user_name");
                              tiny_db.remove("user_type");
                              tiny_db.remove("user_email");
                              tiny_db.remove("user_church_id");
                              tiny_db.remove("user_point");

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GuidePage()),
                              );
                            },
                            child: const Text("예"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, "아니요"),
                            child: const Text("아니요"),
                          ),
                        ],
                      )
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context){
          if(tiny_db.getString("user_church_id") == ""){
            return goChurchView(context);
          }
          else{
            return mainView(context);
          }
        },
      )
    );
  }

  Widget goChurchView(context){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        content: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "교회 아이디",
                          ),
                          onChanged: (value) {
                            input_user_church_id = value;
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async{
                              if(input_user_church_id != "SdbGa9"){
                                showDialog<String>(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          content: const Text("존재하지 않는 교회 아이디 입니다"),
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
                                List<String> _students = [];

                                await firestoreInstance
                                    .collection("churches")
                                    .doc(input_user_church_id)
                                    .get().then(
                                        (value){
                                      _students = value["students"].cast<String>();
                                    }
                                );

                                _students.add(tiny_db.getString("user_email"));

                                await firestoreInstance
                                    .collection("churches")
                                    .doc(input_user_church_id)
                                    .update(
                                    {
                                      "students" : _students,
                                    }
                                );

                                await firestoreInstance
                                    .collection("users")
                                    .doc(tiny_db.getString("user_email"))
                                    .update(
                                    {
                                      "church_id" : input_user_church_id,
                                    }
                                );

                                tiny_db.setString("user_church_id", input_user_church_id);

                                Navigator.pop(context, "확인");
                                setState(() {});
                              }
                            },
                            child: const Text("확인"),
                          ),
                          TextButton(
                            onPressed: () {
                              input_user_church_id = "";
                              Navigator.pop(context, "취소");
                            },
                            child: const Text("취소"),
                          ),
                        ],
                      );
                    }
                );
              },
              child: Text(
                  "교회 참석"
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainView(context){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () async{
                List<String> _db_worship_completion_dates = [];
                DateTime _today_datetime = new DateTime.now();
                String _today_datestring ="${_today_datetime.year.toString()}-${_today_datetime.month.toString().padLeft(2,'0')}-${_today_datetime.day.toString().padLeft(2,'0')}";

                await firestoreInstance
                  .collection("users")
                  .doc(tiny_db.getString("user_email"))
                  .get().then(
                    (value){
                      _db_worship_completion_dates = value["worship_completion_dates"].cast<String>();
                    }
                );

                if(_db_worship_completion_dates.contains(_today_datestring)){
                  showDialog<String>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            content: Text("오늘 이미 예배에 참석하셨습니다"),
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        AttQrimagePage(
                            QrImage(
                              data: tiny_db.getString("user_email"),
                              backgroundColor: Colors.white,
                              size: MediaQuery.of(context).size.width-40,
                            )
                        )
                    ),
                  );

                  _db_worship_completion_dates = [];
                  _today_datetime = new DateTime.now();
                  _today_datestring ="${_today_datetime.year.toString()}-${_today_datetime.month.toString().padLeft(2,'0')}-${_today_datetime.day.toString().padLeft(2,'0')}";

                  await firestoreInstance
                      .collection("users")
                      .doc(tiny_db.getString("user_email"))
                      .get().then(
                          (value){
                        _db_worship_completion_dates = value["worship_completion_dates"].cast<String>();
                      }
                  );

                  if(_db_worship_completion_dates.contains(_today_datestring) == false){
                    showDialog<String>(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              content: const Text("QR코드 인식이 되지 않았거나 오류로 인해 포인트가 적립되지 못하였습니다\n다시 시도해주세요"),
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
                    int _plus_point = 0;
                    int _db_user_point = 0;

                    await firestoreInstance
                        .collection("churches")
                        .doc(tiny_db.getString("user_church_id"))
                        .get().then(
                            (value){
                          _plus_point = value["worship_completion_point"];
                        }
                    );

                    await firestoreInstance
                        .collection("users")
                        .doc(tiny_db.getString("user_email"))
                        .get().then(
                            (value){
                          _db_user_point = value["point"];
                        }
                    );

                    await firestoreInstance
                        .collection("users")
                        .doc(tiny_db.getString("user_email"))
                        .update(
                      {
                        "point" : _db_user_point + _plus_point,
                      }
                    );

                    tiny_db.setInt("user_point", _db_user_point + _plus_point);

                    showDialog<String>(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              content: Text("앗싸! ${_plus_point} 포인트가 적립되었습니다\n좋은 예배 되세요~"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, "확인"),
                                  child: const Text("확인"),
                                ),
                              ],
                            )
                    );

                    setState(() {});
                  }
                }
              },
              child: Text(
                  "예배 출석 QR코드"
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () async{
                List<String> _db_qt_completion_dates = [];
                DateTime _today_datetime = new DateTime.now();
                String _today_datestring ="${_today_datetime.year.toString()}-${_today_datetime.month.toString().padLeft(2,'0')}-${_today_datetime.day.toString().padLeft(2,'0')}";

                await firestoreInstance
                    .collection("users")
                    .doc(tiny_db.getString("user_email"))
                    .get().then(
                        (value){
                      _db_qt_completion_dates = value["qt_completion_dates"].cast<String>();
                    }
                );

                if(_db_qt_completion_dates.contains(_today_datestring)){
                  showDialog<String>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            content: const Text("오늘 이미 QT를 하셨습니다"),
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
                  int _plus_point = 0;
                  int _db_user_point = 0;

                  await firestoreInstance
                      .collection("churches")
                      .doc(tiny_db.getString("user_church_id"))
                      .get().then(
                          (value){
                        _plus_point = value["qt_completion_point"];
                      }
                  );

                  await firestoreInstance
                      .collection("users")
                      .doc(tiny_db.getString("user_email"))
                      .get().then(
                          (value){
                        _db_user_point = value["point"];
                      }
                  );

                  await firestoreInstance
                      .collection("users")
                      .doc(tiny_db.getString("user_email"))
                      .update(
                    {
                      "point" : _db_user_point + _plus_point,
                    }
                  );

                  tiny_db.setInt("user_point", _db_user_point + _plus_point);

                  _db_qt_completion_dates.add(_today_datestring);

                  await firestoreInstance
                      .collection("users")
                      .doc(tiny_db.getString("user_email"))
                      .update(
                      {
                        "qt_completion_dates" : _db_qt_completion_dates,
                      }
                  );

                  showDialog<String>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            content: Text("앗싸! ${_plus_point} 포인트가 적립되었습니다"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, "확인"),
                                child: const Text("확인"),
                              ),
                            ],
                          )
                  );

                  setState(() {});
                }
              },
              child: Text(
                  "오늘 QT 완료"
              ),
            ),
          ),
          Builder(
            builder: (context){
              if(tiny_db.getString("user_type") == "s"){
                return SizedBox();
              }
              else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: const Text("본인 인증"),
                                  content: TextField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "비밀번호",
                                    ),
                                    onChanged: (value) {
                                      input_user_password = value;
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async{
                                        String _db_user_password = "";

                                        await firestoreInstance
                                            .collection("users")
                                            .doc(tiny_db.getString("user_email"))
                                            .get().then(
                                                (value){
                                              _db_user_password = value["password"];
                                            }
                                        );

                                        if(input_user_password != _db_user_password){
                                          showDialog<String>(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    content: const Text("비밀번호가 일치하지 않습니다"),
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
                                          Navigator.pop(context, "확인");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AttQrimageScannerPage()),
                                          );
                                        }
                                      },
                                      child: const Text("확인"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        input_user_church_id = "";
                                        Navigator.pop(context, "취소");
                                      },
                                      child: const Text("취소"),
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        child: const Text("예배 참석 QR코드 스캐너"),
                      ),
                    )
                  ],
                );
              }
            }
          ),
        ],
      ),
    );
  }
}
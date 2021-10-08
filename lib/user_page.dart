import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'custom_theme.dart';
import 'guide_page.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<bool>? is_get = null;

  int monday_point = 0;
  int tuesday_point = 0;
  int wenday_point = 0;
  int thursday_point = 0;
  int friday_point = 0;
  int saturday_point = 0;
  int sunday_point = 0;

  @override
  void initState() {
    is_get = getChurchPoint();
  }

  Future<bool> getChurchPoint() async{
    await firestoreInstance
        .collection("churches")
        .doc(tiny_db.getString("user_church_id"))
        .get()
        .then(
            (value){
          var val = value["worship_completion_points"];
          monday_point = val["월"];
          tuesday_point = val["화"];
          wenday_point = val["수"];
          thursday_point = val["목"];
          friday_point = val["금"];
          saturday_point = val["토"];
          sunday_point = val["일"];
        }
    );

    return true;
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
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Builder(
                      builder: (context) {
                        Widget _display_type = CtTheme.CtIcon.student(Colors.black, 100.0);
                        if(tiny_db.getString("user_type") == "t"){
                          _display_type = CtTheme.CtIcon.teacher(Colors.black, 100.0);
                        }

                        return _display_type;
                      }
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                      "${tiny_db.getString("user_name")}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: CtTheme.CtTextSize.general,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                "개인",
                style: TextStyle(
                  fontSize: CtTheme.CtTextSize.general,
                  color: Colors.black,
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if(tiny_db.getString("user_type") == "s"){
                  return ListTile(
                    title: Text(
                        "학생",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: CtTheme.CtTextSize.general,
                      ),
                    ),
                    tileColor: Color(0xfff8f9fa),
                  );
                }
                else{
                  return ListTile(
                    title: Text(
                        "교사",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: CtTheme.CtTextSize.general,
                      ),
                    ),
                    tileColor: Color(0xfff8f9fa),
                  );
                }
              }
            ),
            ListTile(
              title: Text(
                  "이메일: ${tiny_db.getString("user_email")}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
              tileColor: Color(0xfff8f9fa),
            ),
            ListTile(
              title: Text(
                  "교회 아이디: ${tiny_db.getString("user_church_id")}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
              tileColor: Color(0xfff8f9fa),
            ),
            SizedBox(height: 5.0,),
            ListTile(
              title: Text(
                "교회",
                style: TextStyle(
                  fontSize: CtTheme.CtTextSize.general,
                  color: Colors.black,
                ),
              ),
            ),
            FutureBuilder(
              future: is_get,
              builder: (_, snapshot){
                if(snapshot.hasData){
                  return ListTile(
                    tileColor: Color(0xfff8f9fa),
                    title: Wrap(
                      children: <Widget>[
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: () async{
                            await showDialog<int>(
                              context: context,
                              builder: (BuildContext context) {
                                return new NumberPicker(
                                  minValue: 0,
                                  maxValue: 100,
                                  step: 10,
                                  value: monday_point,
                                  onChanged: (value) {
                                    monday_point = value;
                                  },
                                );
                              },
                            ).then(
                                (value){

                                }
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "월",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${monday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "화",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${tuesday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "수",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${wenday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "목",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${thursday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "금",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${friday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "토",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${saturday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Color(0xfff8f9fa),
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "일",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  "${sunday_point}",
                                  style: TextStyle(
                                      fontSize: CtTheme.CtTextSize.general,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "오류가 생겼습니다",
                      style: TextStyle(
                        fontSize: CtTheme.CtTextSize.general,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
                else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SizedBox(height: 5.0,),
            ListTile(
              title: Text(
                "기타",
                style: TextStyle(
                  fontSize: CtTheme.CtTextSize.general,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              tileColor: Color(0xfff8f9fa),
              leading: Icon(Icons.exit_to_app, color: Colors.black,),
              title: Text(
                  "로그아웃",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
              onTap: (){
                showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("로그아웃 하시겠습니까?",
                        style: TextStyle(
                          fontSize: CtTheme.CtTextSize.general,
                          color: Colors.black,
                        ),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, "아니요"),
                          child: Text("아니요",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                        TextButton(
                          onPressed: () async{
                            EasyLoading.show(status: '로딩중...');

                            await FirebaseAuth.instance.signOut();

                            tiny_db.remove("user_name");
                            tiny_db.remove("user_type");
                            tiny_db.remove("user_email");
                            tiny_db.remove("user_church_id");
                            tiny_db.remove("user_point");

                            EasyLoading.dismiss();

                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                GuidePage()), (Route<dynamic> route) => false);
                          },
                          child: Text("예",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                      ],
                    )
                );
              },
            ),
            ListTile(
              tileColor: Color(0xfff8f9fa),
              leading: Icon(Icons.delete_forever, color: Colors.black,),
              title: Text(
                  "계정 삭제",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
              onTap: (){
                showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("계정을 삭제하시겠습니까?\n(경고 : 다시 계정을 되돌릴 수 없습니다)",
                        style: TextStyle(
                          fontSize: CtTheme.CtTextSize.general,
                          color: Colors.black,
                        ),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, "아니요"),
                          child: Text("아니요",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                        TextButton(
                          onPressed: () async{
                            EasyLoading.show(status: '로딩중...');

                            String _db_user_password = "";
                            await firestoreInstance
                                .collection("users")
                                .doc(tiny_db.getString("user_email"))
                                .get().then(
                                (value){
                                  _db_user_password = value["password"];
                                }
                            );

                            var result = await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
                                EmailAuthProvider.credential(
                                    email: tiny_db.getString("user_email"),
                                    password: _db_user_password
                                ),
                            );
                            await result.user!.delete();

                            await firestoreInstance
                                .collection("users")
                                .doc(tiny_db.getString("user_email"))
                                .delete();

                            if(tiny_db.getString("user_church_id") != ""){
                              String _db_user_type_tag = "students";
                              if(tiny_db.getString("user_type") == "t"){
                                _db_user_type_tag = "teachers";
                              }

                              List<String> _members = [];

                              await firestoreInstance
                                  .collection("churches")
                                  .doc(tiny_db.getString("user_church_id"))
                                  .get().then(
                                      (value){
                                    _members = value[_db_user_type_tag].cast<String>();
                                  }
                              );

                              _members.remove(tiny_db.getString("user_email"));

                              await firestoreInstance
                                  .collection("churches")
                                  .doc(tiny_db.getString("user_church_id"))
                                  .update(
                                  {
                                    _db_user_type_tag : _members
                                  }
                              );
                            }

                            tiny_db.remove("user_name");
                            tiny_db.remove("user_type");
                            tiny_db.remove("user_email");
                            tiny_db.remove("user_church_id");
                            tiny_db.remove("user_point");

                            EasyLoading.dismiss();

                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                GuidePage()), (Route<dynamic> route) => false);
                          },
                          child: Text("예",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                      ],
                    )
                );
              },
            ),
            SizedBox(height: 5.0,),
            ListTile(
              title: Text(
                "v1.0.1",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
              tileColor: Color(0xfff8f9fa),
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}
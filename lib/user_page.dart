import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  Map week_point = {"월" : 0, "화" : 0, "수" : 0, "목" : 0, "금" : 0, "토" : 0, "일" : 0};

  bool is_multi_worship_completion_point = false;

  int qt_completion_point = 0;
  int worship_write_completion_point = 0;

  @override
  void initState() {
    is_get = getData();
  }

  Future<bool> getData() async{
    await firestoreInstance
        .collection("churches")
        .doc(tiny_db.getString("user_church_id"))
        .get()
        .then(
            (value){
          var val = value["worship_completion_points"];
          week_point["월"] = val["월"];
          week_point["화"] = val["화"];
          week_point["수"] = val["수"];
          week_point["목"] = val["목"];
          week_point["금"] = val["금"];
          week_point["토"] = val["토"];
          week_point["일"] = val["일"];

          is_multi_worship_completion_point = value["is_multi_worship_completion_point"];

          qt_completion_point = value["qt_completion_point"];

          worship_write_completion_point = value["worship_write_completion_point"];
        }
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
          ),
          SliverToBoxAdapter(
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
                            else if(tiny_db.getString("user_type") == "m"){
                              _display_type = CtTheme.CtIcon.manager(Colors.black, 100.0);
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
                      return Column(
                        children: <Widget>[
                          ListTile(
                            tileColor: Color(0xfff8f9fa),
                            title: Wrap(
                              children: <Widget>[
                                churchPointButton("월"),
                                churchPointButton("화"),
                                churchPointButton("수"),
                                churchPointButton("목"),
                                churchPointButton("금"),
                                churchPointButton("토"),
                                churchPointButton("일"),
                              ],
                            ),
                          ),
                          ListTile(
                            tileColor: Color(0xfff8f9fa),
                            title: Text(
                              "QT 완료 포인트",
                              style: TextStyle(
                                fontSize: CtTheme.CtTextSize.general,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Text(
                              "${qt_completion_point}",
                              style: TextStyle(
                                fontSize: CtTheme.CtTextSize.general,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () async{
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                      builder: (_, setState){
                                        return AlertDialog(
                                          title: Text(
                                            "QT 완료 포인트",
                                            style: TextStyle(
                                              fontSize: CtTheme.CtTextSize.general,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            "${qt_completion_point}",
                                            style: TextStyle(
                                              fontSize: CtTheme.CtTextSize.general,
                                              color: Colors.black,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.remove_rounded),
                                              onPressed: () async{
                                                if(qt_completion_point == 0){
                                                  return;
                                                }

                                                qt_completion_point--;

                                                await firestoreInstance
                                                    .collection("churches")
                                                    .doc(tiny_db.getString("user_church_id"))
                                                    .update(
                                                    {
                                                      "qt_completion_point" : qt_completion_point
                                                    }
                                                );

                                                setState(() {});
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add_rounded),
                                              onPressed: () async{
                                                if(qt_completion_point == 100){
                                                  return;
                                                }

                                                qt_completion_point++;

                                                await firestoreInstance
                                                    .collection("churches")
                                                    .doc(tiny_db.getString("user_church_id"))
                                                    .update(
                                                    {
                                                      "qt_completion_point" : qt_completion_point
                                                    }
                                                );

                                                setState(() {});
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    ),
                              );

                              setState(() {});
                            },
                          ),
                          ListTile(
                            tileColor: Color(0xfff8f9fa),
                            title: Text(
                              "설교 메모 포인트",
                              style: TextStyle(
                                fontSize: CtTheme.CtTextSize.general,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Text(
                              "${worship_write_completion_point}",
                              style: TextStyle(
                                fontSize: CtTheme.CtTextSize.general,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () async{
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                      builder: (_, setState){
                                        return AlertDialog(
                                          title: Text(
                                            "설교 메모 포인트",
                                            style: TextStyle(
                                              fontSize: CtTheme.CtTextSize.general,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            "${worship_write_completion_point}",
                                            style: TextStyle(
                                              fontSize: CtTheme.CtTextSize.general,
                                              color: Colors.black,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.remove_rounded),
                                              onPressed: () async{
                                                if(worship_write_completion_point == 0){
                                                  return;
                                                }

                                                worship_write_completion_point--;

                                                await firestoreInstance
                                                    .collection("churches")
                                                    .doc(tiny_db.getString("user_church_id"))
                                                    .update(
                                                    {
                                                      "worship_write_completion_point" : worship_write_completion_point
                                                    }
                                                );

                                                setState(() {});
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add_rounded),
                                              onPressed: () async{
                                                if(worship_write_completion_point == 100){
                                                  return;
                                                }

                                                worship_write_completion_point++;

                                                await firestoreInstance
                                                    .collection("churches")
                                                    .doc(tiny_db.getString("user_church_id"))
                                                    .update(
                                                    {
                                                      "worship_write_completion_point" : worship_write_completion_point
                                                    }
                                                );

                                                setState(() {});
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    ),
                              );

                              setState(() {});
                            },
                          ),
                          ListTile(
                            tileColor: Color(0xfff8f9fa),
                            title: Text(
                              "연속 기도회 포인트 적립 가능",
                              style: TextStyle(
                                fontSize: CtTheme.CtTextSize.general,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Switch(
                              value: is_multi_worship_completion_point,
                              onChanged:
                                  (bool value) async{
                                is_multi_worship_completion_point = value;

                                await firestoreInstance
                                    .collection("churches")
                                    .doc(tiny_db.getString("user_church_id"))
                                    .update(
                                    {
                                      "is_multi_worship_completion_point" : value
                                    }
                                );

                                setState(() {});
                              },
                            ),
                          ),
                        ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget churchPointButton(String day_of_week){
    return FlatButton(
      color: Color(0xfff8f9fa),
      onPressed: () async{
        await showDialog(
          context: context,
          builder: (BuildContext context) =>
              StatefulBuilder(
                builder: (_, setState){
                  return AlertDialog(
                    title: Text(
                      "${day_of_week}요일 포인트",
                      style: TextStyle(
                        fontSize: CtTheme.CtTextSize.general,
                        color: Colors.black,
                      ),
                    ),
                    content: Text(
                      "${week_point[day_of_week]}",
                      style: TextStyle(
                        fontSize: CtTheme.CtTextSize.general,
                        color: Colors.black,
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove_rounded),
                        onPressed: () async{
                          if(week_point[day_of_week] == 0){
                            return;
                          }

                          week_point[day_of_week]--;

                          Map<String, dynamic> _worship_completion_points = {};

                          await firestoreInstance
                              .collection("churches")
                              .doc(tiny_db.getString("user_church_id"))
                              .get()
                              .then(
                                  (value){
                                _worship_completion_points = value["worship_completion_points"];
                              }
                          );

                          _worship_completion_points[day_of_week] = week_point[day_of_week];

                          await firestoreInstance
                              .collection("churches")
                              .doc(tiny_db.getString("user_church_id"))
                              .update(
                              {
                                "worship_completion_points" : _worship_completion_points
                              }
                          );

                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_rounded),
                        onPressed: () async{
                          if(week_point[day_of_week] == 100){
                            return;
                          }

                          week_point[day_of_week]++;

                          Map<String, dynamic> _worship_completion_points = {};

                          await firestoreInstance
                              .collection("churches")
                              .doc(tiny_db.getString("user_church_id"))
                              .get()
                              .then(
                                  (value){
                                _worship_completion_points = value["worship_completion_points"];
                              }
                          );

                          _worship_completion_points[day_of_week] = week_point[day_of_week];

                          await firestoreInstance
                              .collection("churches")
                              .doc(tiny_db.getString("user_church_id"))
                              .update(
                              {
                                "worship_completion_points" : _worship_completion_points
                              }
                          );

                          setState(() {});
                        },
                      )
                    ],
                  );
                },
              ),
        );

        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${day_of_week}",
              style: TextStyle(
                  fontSize: CtTheme.CtTextSize.general,
                  color: Colors.black
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              "${week_point[day_of_week]}",
              style: TextStyle(
                  fontSize: CtTheme.CtTextSize.general,
                  color: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'guide_page.dart';

class UserPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

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
      body: Column(
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
                  onTap: (){},
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
                  onTap: (){},
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
            onTap: (){},
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
            onTap: (){},
          ),
          SizedBox(height: 5.0,),
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

                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              GuidePage()), (Route<dynamic> route) => false);
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
                    content: const Text("계정을 삭제하시겠습니까?\n(경고 : 다시 계정을 되돌릴 수 없습니다)"),
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

                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              GuidePage()), (Route<dynamic> route) => false);
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
    );
  }
}
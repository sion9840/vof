import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                Icon(
                  Icons.account_circle,
                  size: 100.0,
                ),
                SizedBox(height: 10.0,),
                Text("${tiny_db.getString("user_name")}"),
              ],
            ),
          ),
          ListTile(
            title: Text("교회 아이디: ${tiny_db.getString("user_church_id")}"),
            tileColor: Colors.white,
            onTap: (){},
          ),
          SizedBox(height: 5.0,),
          ListTile(
            tileColor: Colors.white,
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
            tileColor: Colors.white,
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
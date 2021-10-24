import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vof/my.dart';
import 'global_variable.dart';

import '../lib/my.dart';
import 'main_page.dart';

class SigninPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  String input_user_name = "";
  String input_user_church_id = "";
  String input_user_email = "";
  String input_user_password = "";
  String input_user_passwordcheck = "";
  String input_user_type = "";

  String display_user_type = "학생";

  SigninPage(String _type){
    input_user_type = _type;

    if(input_user_type == "t"){
      display_user_type = "교사";
    }
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
        child: Padding(
          padding: EdgeInsets.all(CtTheme.PaddingSize.general),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${display_user_type} 회원가입",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.FontSize.TooBig,
                ),
              ),
              SizedBox(height: 30.0,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이름(ex:홍길동, 1~10자)",
                ),
                onChanged: (value) {
                  input_user_name = value;
                },
              ),
              SizedBox(height: 10.0,),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "교회 아이디(6글자)",
                ),
                onChanged: (value) {
                  input_user_church_id = value;
                },
              ),
              SizedBox(height: 10.0,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "이메일(.com으로 끝나는 이메일만 가능합니다)",
                ),
                onChanged: (value) {
                  input_user_email = value.trim();
                },
              ),
              SizedBox(height: 10.0,),
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
              SizedBox(height: 10.0,),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "비밀번호 확인",
                ),
                onChanged: (value) {
                  input_user_passwordcheck = value;
                },
              ),
              SizedBox(height: 30.0,),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async{
                    EasyLoading.show(status: '로딩중...');

                    if((1 > input_user_name.length) || (10 < input_user_name.length)) {
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("이름은 1~10자여야 합니다",
                              style: TextStyle(
                                fontSize: CtTheme.FontSize.general,
                                color: Colors.black,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.FontSize.general,
                                    color: Color(CtTheme.HexColor.primary),
                                  ),),
                              ),
                            ],
                          )
                      );
                    }
                    else if(input_user_church_id.length != 6){
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("교회 아이디는 6글자 입니다",
                              style: TextStyle(
                                fontSize: CtTheme.FontSize.general,
                                color: Colors.black,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.FontSize.general,
                                    color: Color(CtTheme.HexColor.primary),
                                  ),),
                              ),
                            ],
                          )
                      );
                    }
                    else if((6 > input_user_password.length) || (16 < input_user_password.length)) {
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("비밀번호는 6~16자여야 합니다",
                              style: TextStyle(
                                fontSize: CtTheme.FontSize.general,
                                color: Colors.black,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.FontSize.general,
                                    color: Color(CtTheme.HexColor.primary),
                                  ),),
                              ),
                            ],
                          )
                      );
                    }
                    else if(input_user_password != input_user_passwordcheck){
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("비밀번호가 일치하지 않습니다",
                              style: TextStyle(
                                fontSize: CtTheme.FontSize.general,
                                color: Colors.black,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.FontSize.general,
                                    color: Color(CtTheme.HexColor.primary),
                                  ),),
                              ),
                            ],
                          )
                      );
                    }
                    else if(input_user_email.contains(".com") == false){
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(".com으로 끝나는 이메일만 가능합니다",
                              style: TextStyle(
                                fontSize: CtTheme.FontSize.general,
                                color: Colors.black,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.FontSize.general,
                                    color: Color(CtTheme.HexColor.primary),
                                  ),),
                              ),
                            ],
                          )
                      );
                    }
                    else if(input_user_church_id != "SdbGa9"){
                      EasyLoading.dismiss();

                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("존재하지 않는 교회 아이디 입니다",
                              style: TextStyle(
                                fontSize: CtTheme.FontSize.general,
                                color: Colors.black,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, "확인"),
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: CtTheme.FontSize.general,
                                    color: Color(CtTheme.HexColor.primary),
                                  ),),
                              ),
                            ],
                          )
                      );
                    }
                    else if(true){
                      bool _is_error = false;

                      try {
                        UserCredential _userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: input_user_email,
                            password: input_user_password
                        );
                      } on FirebaseAuthException catch (e) {
                        _is_error = true;

                        print(e);

                        if (e.code == 'weak-password') {
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    content: Text(
                                        "보안이 약한 비밀번호입니다\n비밀번호를 바꿔주세요",
                                      style: TextStyle(
                                        fontSize: CtTheme.FontSize.general,
                                        color: Colors.black,
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "확인"),
                                        child: Text("확인",
                                          style: TextStyle(
                                            fontSize: CtTheme.FontSize.general,
                                            color: Color(CtTheme.HexColor.primary),
                                          ),),
                                      ),
                                    ],
                                  )
                          );
                        } else if (e.code == 'email-already-in-use') {
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    content: Text("이미 존재하는 이메일입니다",
                                      style: TextStyle(
                                        fontSize: CtTheme.FontSize.general,
                                        color: Colors.black,
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "확인"),
                                        child: Text("확인",
                                          style: TextStyle(
                                            fontSize: CtTheme.FontSize.general,
                                            color: Color(CtTheme.HexColor.primary),
                                          ),),
                                      ),
                                    ],
                                  )
                          );
                        } else if (e.code == 'invalid-email'){
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    content: Text("이메일의 형식이 맞지 않습니다",
                                      style: TextStyle(
                                        fontSize: CtTheme.FontSize.general,
                                        color: Colors.black,
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "확인"),
                                        child: Text("확인",
                                          style: TextStyle(
                                            fontSize: CtTheme.FontSize.general,
                                            color: Color(CtTheme.HexColor.primary),
                                          ),),
                                      ),
                                    ],
                                  )
                          );
                        }
                        else{
                          EasyLoading.dismiss();

                          showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    content: Text("회원가입에 실패하셨습니다",
                                      style: TextStyle(
                                        fontSize: CtTheme.FontSize.general,
                                        color: Colors.black,
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "확인"),
                                        child: Text("확인",
                                          style: TextStyle(
                                            fontSize: CtTheme.FontSize.general,
                                            color: Color(CtTheme.HexColor.primary),
                                          ),),
                                      ),
                                    ],
                                  )
                          );
                        }
                      }

                      if(_is_error == false){
                        await firestoreInstance
                            .collection("users")
                            .doc(input_user_email)
                            .set(
                            {
                              "name" : input_user_name,
                              "type" : input_user_type,
                              "email" : input_user_email,
                              "password" : input_user_password,
                              "church_id" : input_user_church_id,
                              "activity" : [],
                              "point" : 0,
                            });

                        tiny_db.setString("user_name", input_user_name);
                        tiny_db.setString("user_type", input_user_type);
                        tiny_db.setString("user_email", input_user_email);
                        tiny_db.setString("user_church_id", input_user_church_id);
                        tiny_db.setInt("user_point", 0);

                        List<String> _members = [];
                        String _db_user_type_tag = "students";
                        if(input_user_type == "t"){
                          _db_user_type_tag = "teachers";
                        }

                        await firestoreInstance
                            .collection("churches")
                            .doc(input_user_church_id)
                            .get().then(
                                (value){
                              _members = value[_db_user_type_tag].cast<String>();
                            }
                        );

                        _members.add(input_user_email);

                        await firestoreInstance
                            .collection("churches")
                            .doc(input_user_church_id)
                            .update(
                            {
                              _db_user_type_tag : _members
                            }
                        );

                        EasyLoading.dismiss();

                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            MainPage()), (Route<dynamic> route) => false);
                      }
                    }
                  },
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: CtTheme.FontSize.general,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.primary)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.general),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
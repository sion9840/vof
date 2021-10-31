import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vof/my.dart';
import 'package:uuid/uuid.dart';

import 'main_page.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  var attend_church_text_field_controller = TextEditingController();
  var user_name_text_field_controller = TextEditingController();
  var user_password_text_field_controller = TextEditingController();
  var user_password_check_text_field_controller = TextEditingController();

  bool is_error_attend_church_text_field = false;
  bool is_error_user_name_text_field = false;
  bool is_error_user_password_text_field = false;
  bool is_error_user_password_check_text_field = false;

  String attend_church_text_field_error_message = "";
  String user_name_text_field_error_message = "";
  String user_password_text_field_error_message = "";
  String user_password_check_text_field_error_message = "";

  var spec_attend_church_page_view_controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    attend_church_text_field_controller.dispose();
    user_name_text_field_controller.dispose();
    user_password_text_field_controller.dispose();
    user_password_check_text_field_controller.dispose();
    spec_attend_church_page_view_controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.HexColor.Background),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Padding(
              padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  guideAppContainer(),
                  Spacer(
                    flex: 1,
                  ),
                  attendChurchContainer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget guideAppContainer(){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/yay.png",
              width: 263.0,
              height: 270.0,
            ),
            SizedBox(height: 20.0,),
            Text(
              "신앙생활을 통해\n달란트를 모아보아요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(CtTheme.HexColor.Black),
                fontSize: CtTheme.FontSize.TooBig,
                fontFamily: CtTheme.FontFamily.Bold,
              ),
            )
          ],
        )
    );
  }

  Widget attendChurchContainer(){
    return Container(
      decoration: BoxDecoration(
        color: Color(CtTheme.HexColor.White),
        borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Big),
        boxShadow: [
          BoxShadow(
            color: Color(0xffDFE1E3),
            blurRadius: 20,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "교회 참가",
              style: TextStyle(
                color: Color(CtTheme.HexColor.Black),
                fontSize: CtTheme.FontSize.Middle,
                fontFamily: CtTheme.FontFamily.Bold,
              ),
            ),
            SizedBox(
              height: CtTheme.PaddingSize.Middle,
            ),
            TextField( // attend_church_text_field
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(CtTheme.HexColor.Black),
                  ),
                  borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(CtTheme.HexColor.Black),
                  ),
                  borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(CtTheme.HexColor.Black),
                  ),
                  borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                ),
                labelStyle: TextStyle(
                  color: Color(CtTheme.HexColor.Black),
                  fontSize: CtTheme.FontSize.Middle,
                  fontFamily: CtTheme.FontFamily.General,
                ),
                labelText: "교회 아이디",
                errorText: is_error_attend_church_text_field ? attend_church_text_field_error_message : null,
                errorStyle: TextStyle(
                  color: Color(CtTheme.HexColor.Red),
                  fontSize: CtTheme.FontSize.Small,
                  fontFamily: CtTheme.FontFamily.General,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(CtTheme.HexColor.Red),
                  ),
                  borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                ),
              ),
              style: TextStyle(
                color: Color(CtTheme.HexColor.Black),
                fontSize: CtTheme.FontSize.Middle,
                fontFamily: CtTheme.FontFamily.General,
              ),
              controller: attend_church_text_field_controller,
              onChanged: (String value){
                if(attend_church_text_field_controller.text.contains("-") == false){
                  is_error_attend_church_text_field = true;
                  attend_church_text_field_error_message = "교회 아이디 형식이 맞지 않습니다";
                }
                else if(attend_church_text_field_controller.text.length != 36){
                  is_error_attend_church_text_field = true;
                  attend_church_text_field_error_message = "교회 아이디는 36글자 입니다";
                }
                else{
                  is_error_attend_church_text_field = false;
                  attend_church_text_field_error_message = "";
                }

                setState(() {});
              },
              onSubmitted: (String value) {
                if(is_error_attend_church_text_field){
                  return;
                }
                else if(attend_church_text_field_controller.text.length != 36){
                  is_error_attend_church_text_field = true;
                  attend_church_text_field_error_message = "교회 아이디는 36글자 입니다";

                  setState(() {});

                  return;
                }

                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(CtTheme.RadiusSize.Big),
                      topRight: Radius.circular(CtTheme.RadiusSize.Big),
                    ),
                  ),
                  backgroundColor: Color(CtTheme.HexColor.Background),
                  isScrollControlled: true,
                  builder: (context){
                    return specAttendChurchContainer();
                  },
                  //isScrollControlled: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget specAttendChurchContainer() {
    String _church_name = "";
    String _church_main_admin_name = "";

    return StatefulBuilder(
      builder: (context, setState){
        return FutureBuilder(
          future: FirestoreInstance
              .collection("churches")
              .doc(attend_church_text_field_controller.text)
              .get()
              .then(
                  (value) async{
                _church_name = value["name"];

                await FirestoreInstance
                    .collection("churches")
                    .doc(attend_church_text_field_controller.text)
                    .collection("members")
                    .doc(value["main_admin_id"])
                    .get()
                    .then(
                        (value){
                      _church_main_admin_name = value["name"];
                    }
                );

                return 0;
              }
          ),
          builder: (context, snapshot){
            print(snapshot);
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(CtTheme.HexColor.Side2),
                            size: CtTheme.IconSize.Middle,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: PageView(
                            controller: spec_attend_church_page_view_controller,
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              SizedBox.expand(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "처음 등록 하시나요?",
                                          style: TextStyle(
                                            color: Color(CtTheme.HexColor.Black),
                                            fontSize: CtTheme.FontSize.TooBig,
                                            fontFamily: CtTheme.FontFamily.Bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: double.infinity,
                                          height: 250.0,
                                          decoration: BoxDecoration(
                                            color: Color(CtTheme.HexColor.White),
                                            borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Big),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xffDFE1E3),
                                                blurRadius: 20,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${_church_name}",
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.TooBig,
                                                  fontFamily: CtTheme.FontFamily.Bold,
                                                ),
                                              ),
                                              Text(
                                                "주 관리자 : ${_church_main_admin_name}",
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Side2),
                                                  fontSize: CtTheme.FontSize.Middle,
                                                  fontFamily: CtTheme.FontFamily.Bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50.0,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                        ),
                                                      ),
                                                      backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Side1)),
                                                    ),
                                                    child: Text(
                                                      "아니요",
                                                      style: TextStyle(
                                                        color: Color(CtTheme.HexColor.Black),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      is_error_user_name_text_field = false;
                                                      is_error_user_password_text_field = false;
                                                      is_error_user_password_check_text_field = false;

                                                      user_name_text_field_error_message = "";
                                                      user_password_text_field_error_message = "";
                                                      user_password_check_text_field_error_message = "";

                                                      user_name_text_field_controller.clear();
                                                      user_password_text_field_controller.clear();
                                                      user_password_check_text_field_controller.clear();

                                                      setState((){});

                                                      spec_attend_church_page_view_controller.jumpToPage(2);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.0,),
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                        ),
                                                      ),
                                                      backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary2)),
                                                    ),
                                                    child: Text(
                                                      "네",
                                                      style: TextStyle(
                                                        color: Color(CtTheme.HexColor.White),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      is_error_user_name_text_field = false;
                                                      is_error_user_password_text_field = false;
                                                      is_error_user_password_check_text_field = false;

                                                      user_name_text_field_error_message = "";
                                                      user_password_text_field_error_message = "";
                                                      user_password_check_text_field_error_message = "";

                                                      user_name_text_field_controller.clear();
                                                      user_password_text_field_controller.clear();
                                                      user_password_check_text_field_controller.clear();

                                                      setState((){});

                                                      spec_attend_church_page_view_controller.jumpToPage(1);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox.expand(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "교회 등록",
                                          style: TextStyle(
                                            color: Color(CtTheme.HexColor.Black),
                                            fontSize: CtTheme.FontSize.TooBig,
                                            fontFamily: CtTheme.FontFamily.Bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              TextField( // attend_church_text_field
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  labelText: "이름",
                                                  errorText: is_error_user_name_text_field ? user_name_text_field_error_message : null,
                                                  errorStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Red),
                                                    fontSize: CtTheme.FontSize.Small,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Red),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.Middle,
                                                  fontFamily: CtTheme.FontFamily.General,
                                                ),
                                                onChanged: (String value){
                                                  if(((0 < user_name_text_field_controller.text.length) && (user_name_text_field_controller.text.length <= 10)) == false){
                                                    is_error_user_name_text_field = true;
                                                    user_name_text_field_error_message = "이름은 1~10자여야 합니다";
                                                  }
                                                  else{
                                                    is_error_user_name_text_field = false;
                                                    user_name_text_field_error_message = "";
                                                  }

                                                  setState(() {});
                                                },
                                                controller: user_name_text_field_controller,
                                              ),
                                              SizedBox(height: 20.0,),
                                              TextField( // attend_church_text_field
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  labelText: "비밀번호",
                                                  errorText: is_error_user_password_text_field ? user_password_text_field_error_message : null,
                                                  errorStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Red),
                                                    fontSize: CtTheme.FontSize.Small,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Red),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                ),
                                                obscureText: true,
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.Middle,
                                                  fontFamily: CtTheme.FontFamily.General,
                                                ),
                                                onChanged: (String value){
                                                  if(((8 <= user_password_text_field_controller.text.length) && (user_password_text_field_controller.text.length <= 16)) == false){
                                                    is_error_user_password_text_field = true;
                                                    user_password_text_field_error_message = "비밀번호는 8~16자여야 합니다";
                                                  }
                                                  else if((user_password_text_field_controller.text.contains(new RegExp(r'[0-9]'))) == false){
                                                    is_error_user_password_text_field = true;
                                                    user_password_text_field_error_message = "숫자가 포함되어야 합니다";
                                                  }
                                                  else{
                                                    is_error_user_password_text_field = false;
                                                    user_password_text_field_error_message = "";
                                                  }

                                                  setState(() {});
                                                },
                                                onTap: (){
                                                  user_password_check_text_field_controller.clear();

                                                  is_error_user_password_check_text_field = true;
                                                  user_password_check_text_field_error_message = "비밀번호 확인을 입력해주세요";

                                                  setState(() {});
                                                },
                                                controller: user_password_text_field_controller,
                                              ),
                                              SizedBox(height: 20.0,),
                                              TextField( // attend_church_text_field
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  labelText: "비밀번호 확인",
                                                  errorText: is_error_user_password_check_text_field ? user_password_check_text_field_error_message : null,
                                                  errorStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Red),
                                                    fontSize: CtTheme.FontSize.Small,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Red),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                ),
                                                obscureText: true,
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.Middle,
                                                  fontFamily: CtTheme.FontFamily.General,
                                                ),
                                                onChanged: (String value){
                                                  if(user_password_text_field_controller.text != user_password_check_text_field_controller.text){
                                                    is_error_user_password_check_text_field = true;
                                                    user_password_check_text_field_error_message = "비밀번호가 일치하지 않습니다";
                                                  }
                                                  else{
                                                    is_error_user_password_check_text_field = false;
                                                    user_password_check_text_field_error_message = "";
                                                  }

                                                  setState(() {});
                                                },
                                                controller: user_password_check_text_field_controller,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.0,),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "* 입력되는 이름은 이후 다른 사용자가 유저를 식별할때 쓰이므로 정확한 이름을 입력해주세요.",
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.Small,
                                                  fontFamily: CtTheme.FontFamily.General,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50.0,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                        ),
                                                      ),
                                                      backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Side1)),
                                                    ),
                                                    child: Text(
                                                      "뒤로",
                                                      style: TextStyle(
                                                        color: Color(CtTheme.HexColor.Black),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      spec_attend_church_page_view_controller.jumpToPage(0);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.0,),
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                        ),
                                                      ),
                                                      backgroundColor: (
                                                          !is_error_user_name_text_field &&
                                                              !is_error_user_password_text_field &&
                                                              !is_error_user_password_check_text_field &&
                                                              (user_password_text_field_controller.text.length > 0)
                                                      ) ?
                                                      MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary2)) :
                                                      MaterialStateProperty.all<Color>(Color(0xFFF6CC7E)),
                                                    ),
                                                    child: Text(
                                                      "등록",
                                                      style: (
                                                          !is_error_user_name_text_field &&
                                                              !is_error_user_password_text_field &&
                                                              !is_error_user_password_check_text_field &&
                                                              (user_password_text_field_controller.text.length > 0)
                                                      ) ?
                                                      TextStyle(
                                                        color: Color(CtTheme.HexColor.White),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ) :
                                                      TextStyle(
                                                        color: Color(CtTheme.HexColor.White),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if(
                                                      !(!is_error_user_name_text_field &&
                                                          !is_error_user_password_text_field &&
                                                          !is_error_user_password_check_text_field &&
                                                          (user_password_text_field_controller.text.length > 0))
                                                      ){
                                                        return;
                                                      }

                                                      EasyLoading.show(status: '교회 등록 중...');

                                                      var _uuid = Uuid();
                                                      String _user_id = _uuid.v1();
                                                      bool _is_error = false;

                                                      // 클라우드 데이터베이스 관리

                                                      try {
                                                        UserCredential _userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                                            email: "${_user_id}@userid.com",
                                                            password: user_password_text_field_controller.text,
                                                        );
                                                      } on FirebaseAuthException catch (e) {
                                                        _is_error = true;
                                                      }

                                                      if(_is_error){
                                                        EasyLoading.dismiss();

                                                        showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                AlertDialog(
                                                                  content: Text(
                                                                    "교회 등록에 실패하였습니다\n(※ 네트워크 상태를 확인해주세요)",
                                                                    style: TextStyle(
                                                                      color: Color(CtTheme.HexColor.Black),
                                                                      fontSize: CtTheme.FontSize.Middle,
                                                                      fontFamily: CtTheme.FontFamily.General,
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(context),
                                                                      child: Text("확인",
                                                                        style: TextStyle(
                                                                          color: Color(CtTheme.HexColor.Primary2),
                                                                          fontSize: CtTheme.FontSize.Middle,
                                                                          fontFamily: CtTheme.FontFamily.General,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                        );

                                                        return;
                                                      }

                                                      await FirestoreInstance
                                                        .collection("churches")
                                                        .doc(attend_church_text_field_controller.text)
                                                        .collection("members")
                                                        .doc(_user_id)
                                                        .set(
                                                          {
                                                            "id" : _user_id,
                                                            "point" : 0,
                                                            "name" : user_name_text_field_controller.text,
                                                            "password" : user_password_text_field_controller.text,
                                                            "church_id" : attend_church_text_field_controller.text,
                                                            "type" : "student",
                                                            "units" : [],
                                                          }
                                                      );

                                                      // 클라이언트 데이터베이스 관리

                                                      DateTime now = new DateTime.now();
                                                      String _unit_id = _uuid.v1();

                                                      await Hive.box("units").add(
                                                          Unit(
                                                            id: _unit_id,
                                                            type: "look",
                                                            user_id: _user_id,
                                                            okay: true,
                                                            date: {
                                                              "year" : now.year,
                                                              "month" : now.month,
                                                              "day" : now.day,
                                                              "weekday" : now.weekday,
                                                              "hour" : now.hour,
                                                              "minute" : now.minute,
                                                            },
                                                            title: "튜토리얼!",
                                                            content: "",
                                                          )
                                                      );

                                                      TinyDb
                                                        ..setString("user_id", _user_id)
                                                        ..setString("user_church_id", attend_church_text_field_controller.text);

                                                      EasyLoading.dismiss();

                                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                                          MainPage()), (Route<dynamic> route) => false);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox.expand(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "교회 참가",
                                          style: TextStyle(
                                            color: Color(CtTheme.HexColor.Black),
                                            fontSize: CtTheme.FontSize.TooBig,
                                            fontFamily: CtTheme.FontFamily.Bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              TextField( // attend_church_text_field
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  labelText: "이름",
                                                  errorText: is_error_user_name_text_field ? user_name_text_field_error_message : null,
                                                  errorStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Red),
                                                    fontSize: CtTheme.FontSize.Small,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Red),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.Middle,
                                                  fontFamily: CtTheme.FontFamily.General,
                                                ),
                                                onChanged: (String value){
                                                  if(((0 < user_name_text_field_controller.text.length) && (user_name_text_field_controller.text.length <= 10)) == false){
                                                    is_error_user_name_text_field = true;
                                                    user_name_text_field_error_message = "이름은 1~10자여야 합니다";
                                                  }
                                                  else{
                                                    is_error_user_name_text_field = false;
                                                    user_name_text_field_error_message = "";
                                                  }

                                                  setState(() {});
                                                },
                                                controller: user_name_text_field_controller,
                                              ),
                                              SizedBox(height: 20.0,),
                                              TextField( // attend_church_text_field
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Black),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  labelText: "비밀번호",
                                                  errorText: is_error_user_password_text_field ? user_password_text_field_error_message : null,
                                                  errorStyle: TextStyle(
                                                    color: Color(CtTheme.HexColor.Red),
                                                    fontSize: CtTheme.FontSize.Small,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(CtTheme.HexColor.Red),
                                                    ),
                                                    borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                  ),
                                                ),
                                                obscureText: true,
                                                style: TextStyle(
                                                  color: Color(CtTheme.HexColor.Black),
                                                  fontSize: CtTheme.FontSize.Middle,
                                                  fontFamily: CtTheme.FontFamily.General,
                                                ),
                                                onChanged: (String value){
                                                  if(((8 <= user_password_text_field_controller.text.length) && (user_password_text_field_controller.text.length <= 16)) == false){
                                                    is_error_user_password_text_field = true;
                                                    user_password_text_field_error_message = "비밀번호는 8~16자여야 합니다";
                                                  }
                                                  else if((user_password_text_field_controller.text.contains(new RegExp(r'[0-9]'))) == false){
                                                    is_error_user_password_text_field = true;
                                                    user_password_text_field_error_message = "숫자가 포함되어야 합니다";
                                                  }
                                                  else{
                                                    is_error_user_password_text_field = false;
                                                    user_password_text_field_error_message = "";
                                                  }

                                                  setState(() {});
                                                },
                                                onTap: (){
                                                  user_password_check_text_field_controller.clear();

                                                  is_error_user_password_check_text_field = true;
                                                },
                                                controller: user_password_text_field_controller,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50.0,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                        ),
                                                      ),
                                                      backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Side1)),
                                                    ),
                                                    child: Text(
                                                      "뒤로",
                                                      style: TextStyle(
                                                        color: Color(CtTheme.HexColor.Black),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      spec_attend_church_page_view_controller.jumpToPage(0);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.0,),
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 50.0,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                        ),
                                                      ),
                                                      backgroundColor: (
                                                          !is_error_user_name_text_field &&
                                                              !is_error_user_password_text_field &&
                                                              (user_password_text_field_controller.text.length > 0)
                                                      ) ?
                                                      MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary2)) :
                                                      MaterialStateProperty.all<Color>(Color(0xFFF6CC7E)),
                                                    ),
                                                    child: Text(
                                                      "참가",
                                                      style: (
                                                          !is_error_user_name_text_field &&
                                                              !is_error_user_password_text_field &&
                                                              (user_password_text_field_controller.text.length > 0)
                                                      ) ?
                                                      TextStyle(
                                                        color: Color(CtTheme.HexColor.White),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ) :
                                                      TextStyle(
                                                        color: Color(CtTheme.HexColor.White),
                                                        fontSize: CtTheme.FontSize.Middle,
                                                        fontFamily: CtTheme.FontFamily.General,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if(
                                                      !(!is_error_user_name_text_field &&
                                                          !is_error_user_password_text_field &&
                                                          (user_password_text_field_controller.text.length > 0))
                                                      ){
                                                        return;
                                                      }

                                                      EasyLoading.show(status: "교회 참가 중...");

                                                      bool _is_error = false;
                                                      var _searched_user_doc;

                                                      // 클라우드 데이터베이스 관리

                                                      await FirestoreInstance
                                                        .collection("churches")
                                                        .doc(attend_church_text_field_controller.text)
                                                        .collection("members")
                                                        .where("name", isEqualTo: user_name_text_field_controller.text)
                                                        .get()
                                                        .then(
                                                          (value){
                                                            _searched_user_doc = value.docs[0];
                                                          },
                                                        )
                                                        .catchError(
                                                          (e){
                                                            _is_error = true;

                                                            print("ERROR:${e.message}");
                                                          }
                                                      );

                                                      if(_is_error){
                                                        EasyLoading.dismiss();

                                                        return;
                                                      }

                                                      if(user_password_text_field_controller.text != _searched_user_doc["password"]) {
                                                        EasyLoading.dismiss();

                                                        showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                AlertDialog(
                                                                  content: Text(
                                                                    "비밀번호가 틀렸습니다",
                                                                    style: TextStyle(
                                                                      color: Color(CtTheme.HexColor.Black),
                                                                      fontSize: CtTheme.FontSize.Middle,
                                                                      fontFamily: CtTheme.FontFamily.General,
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(context),
                                                                      child: Text("확인",
                                                                        style: TextStyle(
                                                                          color: Color(CtTheme.HexColor.Primary2),
                                                                          fontSize: CtTheme.FontSize.Middle,
                                                                          fontFamily: CtTheme.FontFamily.General,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                        );

                                                        return;
                                                      }

                                                      // 클라이언트 데이터베이스 관리

                                                      TinyDb
                                                        ..setString("user_id", _searched_user_doc["id"])
                                                        ..setString("user_church_id", attend_church_text_field_controller.text);

                                                      EasyLoading.dismiss();

                                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                                          MainPage()), (Route<dynamic> route) => false);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            else if(snapshot.hasError){
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Center(
                  child: CtTheme.Icon.Error(Color(CtTheme.HexColor.Black), CtTheme.IconSize.Middle),
                ),
              );
            }
            else{
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Center(
                  child: CtTheme.Icon.Loading(Color(CtTheme.HexColor.Black)),
                ),
              );
            }
          },
        );
      },
    );
  }
}
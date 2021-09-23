import 'package:flutter/material.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/signin_page.dart';

import 'login_page.dart';
import 'signin_page.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(CtTheme.CtPaddingSize.general),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text(
                "믿음의 항해를 통해 포인트를 적립하세요",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                    color: Color(CtTheme.CtHexColor.primary),
                  ),
                  child: Center(
                    child: Text(
                      "로그인",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: CtTheme.CtTextSize.general,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              InkWell(
                onTap: (){
                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, "교사로 회원가입");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SigninPage("t")),
                                  );
                                },
                                child: const Text("교사로 회원가입"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, "학생으로 회원가입");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SigninPage("s")),
                                  );
                                },
                                child: const Text("학생으로 회원가입"),
                              ),
                            ],
                          ),
                        ],
                      )
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                    border: Border.all(color: Color(CtTheme.CtHexColor.primary), width: 1, ),
                  ),
                  child: Center(
                    child: Text(
                      "회원가입",
                      style: TextStyle(
                        color: Color(CtTheme.CtHexColor.primary),
                        fontSize: CtTheme.CtTextSize.general,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async{
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("앱을 종류하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("네"),
              onPressed: ()=>Navigator.pop(context, true),
            ),
            TextButton(
              child: Text("아니요"),
              onPressed: ()=>Navigator.pop(context, false),
            ),
          ],
        )
    ) ??
        false;
  }
}
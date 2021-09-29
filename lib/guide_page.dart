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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(CtTheme.CtPaddingSize.general),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Image.asset("img/boat.png"),
            Text(
              "믿음의 항해를 통해\n포인트를 적립하세요",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: CtTheme.CtTextSize.general,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: CtTheme.CtTextSize.general,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.CtHexColor.primary)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                      )),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: OutlinedButton(
                onPressed: () {
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
                child: Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: CtTheme.CtTextSize.general,
                    color: Color(CtTheme.CtHexColor.primary),
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                      )),
                    side: MaterialStateProperty.all(
                        BorderSide(
                          color: Color(CtTheme.CtHexColor.primary),
                          width: 1.0,
                          style: BorderStyle.solid)
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vof/signin_page.dart';

import 'login_page.dart';
import 'signin_page.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("안내"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Text(
              "믿음의 항해를 통해 포인트를 적립하세요",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("로그인"),

              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
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
                child: Text("회원가입"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
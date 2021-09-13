import 'package:flutter/material.dart';

import 'login_page.dart';
import 'student_signin1_page.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TeacherSignIn1Page()),
                              );
                            },
                            child: const Text("교사로 회원가입"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StudentSignIn1Page()),
                              );
                            },
                            child: const Text("학생으로 회원가입"),
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
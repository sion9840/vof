import 'package:flutter/material.dart';

import 'package:vof/signin2_page.dart';

class SignIn1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _church_id = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입 > 교회 찾기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                  labelText: "교회 아이디(6자리)",
              ),
              onChanged: (value) {
                _church_id = value;
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  if(_church_id.length != 6){
                    showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("6자리가 아닙니다"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, "확인"),
                              child: const Text("확인"),
                            ),
                          ],
                        )
                    );
                  }
                  else if(_church_id != "sDB984"){
                    showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("존재하지 않는 교회 아이디 입니다"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, "확인"),
                              child: const Text("확인"),
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signin2Page()),
                    );
                  }
                },
                child: Text("확인"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
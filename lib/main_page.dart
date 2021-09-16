import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vof/att_qrimage_page.dart';
import 'package:vof/global_variable.dart';

import 'guide_page.dart';

class MainPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vof 포인트"),
      ),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Text(
                "안녕하세요\n${tiny_db.getStringList("user")![1]}님",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: 20,),
              Spacer(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("로그아웃"),
                onTap: (){
                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text("로그아웃 하시겠습니까?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: (){
                              tiny_db.remove("user");

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GuidePage()),
                              );
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
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        AttQrimagePage(
                            QrImage(
                              data: tiny_db.getStringList("user")![0],
                              backgroundColor: Colors.white,
                              size: MediaQuery.of(context).size.width-40,
                            )
                        )
                    ),
                  );
                },
                child: Text(
                    "교회 출석 QR코드"
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: (){

                },
                child: Text(
                    "오늘 QT 완료"
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
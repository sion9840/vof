import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vof/att_qrimage_page.dart';
import 'dart:ui';

import 'guide_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _firestoreInstance = FirebaseFirestore.instance;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return Scaffold(
      appBar: AppBar(
        title: Text("Vof 포인트"),
      ),
      drawer: Drawer(
        child: FutureBuilder<SharedPreferences>(
            future: _prefs,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Text(
                        "안녕하세요\n${snapshot.data!.getStringList("user")![0]}님",
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
                                      snapshot.data!.remove("user");

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
                );
              }
              else if(snapshot.hasError){
                return Center(
                  child: Text(
                    "뒤로 이동해주세요",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
        ),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: _prefs,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Padding(
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
                                    data: snapshot.data!.getStringList("user")![2],
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
                ],
              ),
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: Text(
                "뒤로 이동해주세요",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}
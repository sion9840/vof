import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'pointspec_page.dart';

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          "구성원",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firestoreInstance.collection("users").where("church_id", isEqualTo: tiny_db.getString("user_church_id")).get().then((value) => value),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index){
                      dynamic _user = snapshot.data!.docs[index];

                      return Column(
                        children: <Widget>[
                          Builder(
                              builder: (context) {
                                if(index == 0){
                                  return SizedBox(height: 10.0,);
                                }
                                else{
                                  return Divider(
                                    thickness: 2.0,
                                    height: 20,
                                    color: Colors.black12,
                                  );
                                }
                              }
                          ),
                          ListTile(
                            onTap: () async{
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PointspecPage(_user["email"], _user["type"], _user["name"], _user["point"])),
                              );

                              setState(() {});
                            },
                            leading: Builder(
                              builder: (context){
                                if(_user["type"] == "s"){
                                  return Text(
                                    "학생",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: CtTheme.CtTextSize.general,
                                    ),
                                  );
                                }
                                else{
                                  return Text(
                                    "선생님",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: CtTheme.CtTextSize.general,
                                    ),
                                  );
                                }
                              },
                            ),
                            title: Text(
                              "${_user["name"]}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: CtTheme.CtTextSize.general,
                              ),
                            ),
                            trailing: Text(
                              "${_user["point"]} 포인트",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: CtTheme.CtTextSize.general,
                              ),
                            ),
                          ),
                        ],
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
                  "오류가 생겼습니다"
              ),
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
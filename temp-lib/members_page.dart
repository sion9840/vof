import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vof/_.dart';
import 'global_variable.dart';

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
                                    color: Color(0xfff8f9fa),
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
                                Widget _display_type = CtTheme.Icon.Student(Colors.black, 24.0);
                                if(_user["type"] == "t"){
                                  _display_type = CtTheme.Icon.Teacher(Colors.black, 24.0);
                                }
                                else if(_user["type"] == "m"){
                                  _display_type = CtTheme.Icon.Manager(Colors.black, 24.0);
                                }

                                return _display_type;
                              },
                            ),
                            title: Text(
                              "${_user["name"]}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: CtTheme.FontSize.general,
                              ),
                            ),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "${_user["point"]}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: CtTheme.FontSize.general,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                CtTheme.Icon.Point(Colors.black, 24.0),
                              ],
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
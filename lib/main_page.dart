import 'package:flutter/material.dart';
import 'package:vof/_.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var user_doc;
  var church_doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.HexColor.Background),
      body: FutureBuilder(
        future: FirestoreInstance
          .collection("churches")
          .doc(ClientDbInstance.getString("user_church_id"))
          .get().then(
            (value) async{
              church_doc = value;

              await FirestoreInstance
                .collection("churches")
                .doc(ClientDbInstance.getString("user_church_id"))
                .collection("members")
                .doc(ClientDbInstance.getString("user_id"))
                .get().then(
                  (value){
                    user_doc = value;
                  }
              );

              return 0;
            }
        ),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Padding(
              padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: CtTheme.Icon.Account(Color(CtTheme.HexColor.Black), CtTheme.IconSize.Big),
                    title: Text(
                      "${user_doc["name"]}",
                      style: TextStyle(
                        color: Color(CtTheme.HexColor.Black),
                        fontSize: CtTheme.FontSize.Big
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: CtTheme.Icon.Error(Color(CtTheme.HexColor.Black), CtTheme.IconSize.Middle),
            );
          }
          else{
            return Center(
              child: CtTheme.Icon.Loading(Color(CtTheme.HexColor.Black)),
            );
          }
        },
      ),
    );
  }
}
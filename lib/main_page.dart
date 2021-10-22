import 'package:flutter/material.dart';
import 'package:vof/_.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ;
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
                    title: "${user_doc["user_name"]}",
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
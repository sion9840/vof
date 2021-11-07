import 'package:flutter/material.dart';
import 'package:vof/my.dart';

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
          .doc(TinyDb.getString("user_church_id"))
          .get().then(
            (value) async{
              church_doc = value;

              await FirestoreInstance
                .collection("churches")
                .doc(TinyDb.getString("user_church_id"))
                .collection("members")
                .doc(TinyDb.getString("user_id"))
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
            return CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
                  sliver: SliverAppBar(
                    backgroundColor: Color(CtTheme.HexColor.Background),
                    leading: IconButton(
                      icon: CtTheme.Icon.Account(Color(CtTheme.HexColor.Black), CtTheme.IconSize.Middle),
                      iconSize: CtTheme.IconSize.Middle,
                      onPressed: (){

                      },
                    ),
                    title: Text(
                      "${user_doc["name"]}",
                      style: TextStyle(
                        color: Color(CtTheme.HexColor.Black),
                        fontSize: CtTheme.FontSize.Big
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        bottom: 30.0,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(CtTheme.HexColor.White),
                        borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Big),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffDFE1E3),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "나의 달란트",
                              style: TextStyle(
                                color: Color(CtTheme.HexColor.Side2),
                                fontSize: CtTheme.FontSize.Middle,
                                fontFamily: CtTheme.FontFamily.General,
                              ),
                            ),
                            SizedBox(height: 2.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "${user_doc["point"]} 포인트",
                                    style: TextStyle(
                                      color: Color(CtTheme.HexColor.Black),
                                      fontSize: CtTheme.FontSize.TooBig,
                                      fontFamily: CtTheme.FontFamily.Bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: CtTheme.IconSize.Middle,
                                    color: Color(CtTheme.HexColor.Black),
                                  ),
                                  onPressed: (){

                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0,),
                            SizedBox(
                              width: double.infinity,
                              height: 50.0,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary2)),
                                        ),
                                        child: Text(
                                          "QT 하기",
                                          style: TextStyle(
                                            color: Color(CtTheme.HexColor.White),
                                            fontSize: CtTheme.FontSize.Middle,
                                            fontFamily: CtTheme.FontFamily.General,
                                          ),
                                        ),
                                        onPressed: () {
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary2)),
                                        ),
                                        child: Text(
                                          "예배 참석",
                                          style: TextStyle(
                                            color: Color(CtTheme.HexColor.White),
                                            fontSize: CtTheme.FontSize.Middle,
                                            fontFamily: CtTheme.FontFamily.General,
                                          ),
                                        ),
                                        onPressed: () {
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary2)),
                                        ),
                                        child: Text(
                                          "설교 메모",
                                          style: TextStyle(
                                            color: Color(CtTheme.HexColor.White),
                                            fontSize: CtTheme.FontSize.Middle,
                                            fontFamily: CtTheme.FontFamily.General,
                                          ),
                                        ),
                                        onPressed: () {
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
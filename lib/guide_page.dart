import 'package:flutter/material.dart';
import 'package:vof/_.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  var attend_church_text_field_controller = TextEditingController();
  var spec_attend_church_page_view_controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    attend_church_text_field_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.HexColor.Background),
      body: Padding(
        padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            attendChurchContainer(),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "OR",
              style: TextStyle(
                color: Color(CtTheme.HexColor.Side),
                fontSize: CtTheme.FontSize.Big,
                fontFamily: CtTheme.FontFamily.Bold,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            makeChurchContainer(),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget attendChurchContainer(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "교회에 참석하세요!",
            style: TextStyle(
              color: Color(CtTheme.HexColor.Black),
              fontSize: CtTheme.FontSize.Big,
              fontFamily: CtTheme.FontFamily.Bold,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          TextField( // attend_church_text_field
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(CtTheme.HexColor.Primary3),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(CtTheme.HexColor.Primary3),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
              ),
              labelStyle: TextStyle(
                color: Color(CtTheme.HexColor.Primary3),
                fontSize: CtTheme.FontSize.Middle,
                fontFamily: CtTheme.FontFamily.General,
              ),
              labelText: "교회 아이디",
            ),
            style: TextStyle(
              color: Color(CtTheme.HexColor.Black),
              fontSize: CtTheme.FontSize.Middle,
              fontFamily: CtTheme.FontFamily.General,
            ),
            controller: attend_church_text_field_controller,
            onSubmitted: (String value) {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(CtTheme.RadiusSize.Big),
                    topRight: Radius.circular(CtTheme.RadiusSize.Big),
                  ),
                ),
                backgroundColor: Color(CtTheme.HexColor.Background),
                builder: (context) => specAttendChurchContainer(),
                //isScrollControlled: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget makeChurchContainer(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "교회를 만드세요!",
            style: TextStyle(
              color: Color(CtTheme.HexColor.Black),
              fontSize: CtTheme.FontSize.Big,
              fontFamily: CtTheme.FontFamily.Bold,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          SizedBox(
            width: double.infinity,
            height: 50.0,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                      ),
                  ),
                backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary3)),
              ),
              child: Text(
                "교회 만들기",
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
        ],
      ),
    );
  }

  Widget specAttendChurchContainer() {
    String _church_name = "";
    String _church_main_admin_name = "";

    return FutureBuilder(
      future: FirestoreInstance
          .collection("churches")
          .doc(attend_church_text_field_controller.text)
          .get()
          .then(
            (value) async{
              _church_name = value["church_name"];

              await FirestoreInstance
                .collection("churches")
                .doc(attend_church_text_field_controller.text)
                .collection("members")
                .doc(value["church_main_admin_id"])
                .get()
                .then(
                  (value){
                    _church_main_admin_name = value["user_name"];
                  }
              );

              return 0;
            }
      ),
      builder: (context, snapshot){
        print(snapshot);
        if(snapshot.hasData){
          return Container(
            child: PageView(
              controller: spec_attend_church_page_view_controller,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                SizedBox.expand(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(CtTheme.PaddingSize.Middle * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "이 교회가 맞나요?",
                            style: TextStyle(
                              color: Color(CtTheme.HexColor.Black),
                              fontSize: CtTheme.FontSize.Big,
                              fontFamily: CtTheme.FontFamily.Bold,
                            ),
                          ),
                          Text(
                            "1 / 3",
                            style: TextStyle(
                              color: Color(CtTheme.HexColor.Side),
                              fontSize: CtTheme.FontSize.Middle,
                              fontFamily: CtTheme.FontFamily.Bold,
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: double.infinity,
                            height: 170.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(CtTheme.RadiusSize.Middle)),
                              border: Border.all(
                                color: Color(CtTheme.HexColor.Black),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${_church_name}",
                                  style: TextStyle(
                                    color: Color(CtTheme.HexColor.Black),
                                    fontSize: CtTheme.FontSize.Big,
                                    fontFamily: CtTheme.FontFamily.Bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(CtTheme.HexColor.Primary3),
                                    decorationStyle: TextDecorationStyle.wavy,
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                Text(
                                  "주 관리자 : ${_church_main_admin_name}",
                                  style: TextStyle(
                                    color: Color(CtTheme.HexColor.Side),
                                    fontSize: CtTheme.FontSize.Middle,
                                    fontFamily: CtTheme.FontFamily.Bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50.0,
                                    child: TextButton(
                                      child: Text(
                                        "아니요",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.Black),
                                          fontSize: CtTheme.FontSize.Middle,
                                          fontFamily: CtTheme.FontFamily.General,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    height: 50.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary3)),
                                      ),
                                      child: Text(
                                        "네",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.White),
                                          fontSize: CtTheme.FontSize.Middle,
                                          fontFamily: CtTheme.FontFamily.General,
                                        ),
                                      ),
                                      onPressed: () {
                                        spec_attend_church_page_view_controller.animateToPage(
                                          1,
                                          duration: const Duration(microseconds: 250),
                                          curve: Curves.bounceIn,
                                        );
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
                SizedBox.expand(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(CtTheme.PaddingSize.Middle * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "처음 등록 하시나요?",
                            style: TextStyle(
                              color: Color(CtTheme.HexColor.Black),
                              fontSize: CtTheme.FontSize.Big,
                              fontFamily: CtTheme.FontFamily.Bold,
                            ),
                          ),
                          Text(
                            "2 / 3",
                            style: TextStyle(
                              color: Color(CtTheme.HexColor.Side),
                              fontSize: CtTheme.FontSize.Middle,
                              fontFamily: CtTheme.FontFamily.Bold,
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: double.infinity,
                            height: 170.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(CtTheme.RadiusSize.Middle)),
                              border: Border.all(
                                color: Color(CtTheme.HexColor.Black),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${_church_name}",
                                  style: TextStyle(
                                    color: Color(CtTheme.HexColor.Black),
                                    fontSize: CtTheme.FontSize.Big,
                                    fontFamily: CtTheme.FontFamily.Bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(CtTheme.HexColor.Primary3),
                                    decorationStyle: TextDecorationStyle.wavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50.0,
                                    child: TextButton(
                                      child: Text(
                                        "아니요",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.Black),
                                          fontSize: CtTheme.FontSize.Middle,
                                          fontFamily: CtTheme.FontFamily.General,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    height: 50.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Primary3)),
                                      ),
                                      child: Text(
                                        "네",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.White),
                                          fontSize: CtTheme.FontSize.Middle,
                                          fontFamily: CtTheme.FontFamily.General,
                                        ),
                                      ),
                                      onPressed: () {
                                        spec_attend_church_page_view_controller.jumpToPage(1);
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
              ],
            ),
          );
        }
        else if(snapshot.hasError){
          return Container(
            child: Center(
              child: CtTheme.Icon.Error(Color(CtTheme.HexColor.Black), CtTheme.IconSize.Middle),
            ),
          );
        }
        else{
          return Container(
            child: Center(
              child: CtTheme.Icon.Loading(Color(CtTheme.HexColor.Black)),
            ),
          );
        }
      },
    );
  }
}
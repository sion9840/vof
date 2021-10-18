import 'package:flutter/material.dart';
import 'package:vof/_.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  var attend_church_text_field_controller = TextEditingController();
  var user_name_text_field_controller = TextEditingController();
  var user_password_text_field_controller = TextEditingController();
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
              height: 20.0,
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
                  color: Color(CtTheme.HexColor.Black),
                ),
                borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(CtTheme.HexColor.Black),
                ),
                borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(CtTheme.HexColor.Black),
                ),
                borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
              ),
              labelStyle: TextStyle(
                color: Color(CtTheme.HexColor.Black),
                fontSize: CtTheme.FontSize.Middle,
                fontFamily: CtTheme.FontFamily.General,
              ),
              labelText: "교회 아이디",
              suffixIcon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: IconButton(
                  onPressed: (){
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
                  icon: Icon(
                    Icons.east_rounded,
                    size: CtTheme.IconSize.Middle,
                    color: Color(CtTheme.HexColor.Black),
                  ),
                ),
              ),
            ),
            style: TextStyle(
              color: Color(CtTheme.HexColor.Black),
              fontSize: CtTheme.FontSize.Middle,
              fontFamily: CtTheme.FontFamily.General,
            ),
            controller: attend_church_text_field_controller,
          ),
        ],
      ),
    );
  }

  Widget makeChurchContainer(){
    return Container(
      child: TextButton(
        child: Text(
          "교회를 만들고 싶나요?",
          style: TextStyle(
            color: Color(CtTheme.HexColor.Side),
            fontSize: CtTheme.FontSize.Small,
            fontFamily: CtTheme.FontFamily.General,
            decoration: TextDecoration.underline,
            decorationColor: Color(CtTheme.HexColor.Side),
          ),
        ),
        onPressed: (){

        },
      )
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
                      padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
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
                            height: 200.0,
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
                                    fontSize: CtTheme.FontSize.Middle,
                                    fontFamily: CtTheme.FontFamily.General,
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
                                    fontSize: CtTheme.FontSize.Small,
                                    fontFamily: CtTheme.FontFamily.General,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 70.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 70.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "아니요",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.Black),
                                          fontSize: CtTheme.FontSize.Small,
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
                                  flex: 3,
                                  child: SizedBox(
                                    height: 70.0,
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
                                          fontSize: CtTheme.FontSize.Small,
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
                      padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
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
                            height: 200.0,
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
                                    fontSize: CtTheme.FontSize.Middle,
                                    fontFamily: CtTheme.FontFamily.General,
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
                                    fontSize: CtTheme.FontSize.Small,
                                    fontFamily: CtTheme.FontFamily.General,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 70.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 70.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "아니요",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.Black),
                                          fontSize: CtTheme.FontSize.Small,
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
                                  flex: 3,
                                  child: SizedBox(
                                    height: 70.0,
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
                                          fontSize: CtTheme.FontSize.Small,
                                          fontFamily: CtTheme.FontFamily.General,
                                        ),
                                      ),
                                      onPressed: () {
                                        spec_attend_church_page_view_controller.jumpToPage(2);
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
                      padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "교회 등록",
                            style: TextStyle(
                              color: Color(CtTheme.HexColor.Black),
                              fontSize: CtTheme.FontSize.Big,
                              fontFamily: CtTheme.FontFamily.Bold,
                            ),
                          ),
                          Text(
                            "3 / 3",
                            style: TextStyle(
                              color: Color(CtTheme.HexColor.Side),
                              fontSize: CtTheme.FontSize.Middle,
                              fontFamily: CtTheme.FontFamily.Bold,
                            ),
                          ),
                          Spacer(),
                          Container(
                            child: Column(
                              children: <Widget>[
                                TextField( // attend_church_text_field
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(CtTheme.HexColor.Black),
                                      ),
                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(CtTheme.HexColor.Black),
                                      ),
                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(CtTheme.HexColor.Black),
                                      ),
                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Color(CtTheme.HexColor.Black),
                                      fontSize: CtTheme.FontSize.Middle,
                                      fontFamily: CtTheme.FontFamily.General,
                                    ),
                                    labelText: "이름",
                                  ),
                                  style: TextStyle(
                                    color: Color(CtTheme.HexColor.Black),
                                    fontSize: CtTheme.FontSize.Middle,
                                    fontFamily: CtTheme.FontFamily.General,
                                  ),
                                  controller: user_name_text_field_controller,
                                ),
                                SizedBox(height: 20.0,),
                                TextField( // attend_church_text_field
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(CtTheme.HexColor.Black),
                                      ),
                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(CtTheme.HexColor.Black),
                                      ),
                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(CtTheme.HexColor.Black),
                                      ),
                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Color(CtTheme.HexColor.Black),
                                      fontSize: CtTheme.FontSize.Middle,
                                      fontFamily: CtTheme.FontFamily.General,
                                    ),
                                    labelText: "비밀번호",
                                  ),
                                  style: TextStyle(
                                    color: Color(CtTheme.HexColor.Black),
                                    fontSize: CtTheme.FontSize.Middle,
                                    fontFamily: CtTheme.FontFamily.General,
                                  ),
                                  controller: user_password_text_field_controller,
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 70.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 70.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "뒤로",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.Black),
                                          fontSize: CtTheme.FontSize.Small,
                                          fontFamily: CtTheme.FontFamily.General,
                                        ),
                                      ),
                                      onPressed: () {
                                        spec_attend_church_page_view_controller.jumpToPage(1);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    height: 70.0,
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
                                        "등록",
                                        style: TextStyle(
                                          color: Color(CtTheme.HexColor.White),
                                          fontSize: CtTheme.FontSize.Small,
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
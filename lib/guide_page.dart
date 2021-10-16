import 'package:flutter/material.dart';
import 'package:vof/_.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  var attend_church_text_field_controller = TextEditingController();

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
}
import 'package:flutter/cupertino.dart';
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
  var user_password_check_text_field_controller = TextEditingController();
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
    user_name_text_field_controller.dispose();
    user_password_text_field_controller.dispose();
    user_password_check_text_field_controller.dispose();
    spec_attend_church_page_view_controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.HexColor.Background),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                guideAppContainer(),
                Spacer(
                  flex: 1,
                ),
                attendChurchContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget guideAppContainer(){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/yay.png",
              width: 272.0,
              height: 279.0,
            ),
            SizedBox(height: 20.0,),
            Text(
              "신앙생활을 통해\n달란트를 모아보아요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(CtTheme.HexColor.Black),
                fontSize: CtTheme.FontSize.Big,
                fontFamily: CtTheme.FontFamily.Bold,
              ),
            )
          ],
        )
    );
  }

  Widget attendChurchContainer(){
    return Container(
      decoration: BoxDecoration(
        color: Color(CtTheme.HexColor.White),
        borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Big),
        boxShadow: [
          BoxShadow(
            color: Color(0xfff1f2f3),
            blurRadius: 20,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "교회 참가",
              style: TextStyle(
                color: Color(CtTheme.HexColor.Black),
                fontSize: CtTheme.FontSize.Middle,
                fontFamily: CtTheme.FontFamily.Bold,
              ),
            ),
            SizedBox(
              height: CtTheme.PaddingSize.Middle,
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
                  isScrollControlled: true,
                  builder: (context){
                    return specAttendChurchContainer();
                  },
                  //isScrollControlled: true,
                );
              },
            ),
          ],
        ),
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
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(CtTheme.HexColor.Side2),
                        size: CtTheme.IconSize.Middle,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
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
                                      "처음 등록 하시나요?",
                                      style: TextStyle(
                                        color: Color(CtTheme.HexColor.Black),
                                        fontSize: CtTheme.FontSize.Big,
                                        fontFamily: CtTheme.FontFamily.Bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: double.infinity,
                                      height: 250.0,
                                      decoration: BoxDecoration(
                                        color: Color(CtTheme.HexColor.White),
                                        borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Big),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xfff1f2f3),
                                            blurRadius: 20,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
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
                                            ),
                                          ),
                                          Text(
                                            "주 관리자 : ${_church_main_admin_name}",
                                            style: TextStyle(
                                              color: Color(CtTheme.HexColor.Side2),
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
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                    ),
                                                  ),
                                                  backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Side1)),
                                                ),
                                                child: Text(
                                                  "아니요",
                                                  style: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  spec_attend_church_page_view_controller.jumpToPage(2);
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
                                              labelText: "비밀번호 확인",
                                            ),
                                            style: TextStyle(
                                              color: Color(CtTheme.HexColor.Black),
                                              fontSize: CtTheme.FontSize.Middle,
                                              fontFamily: CtTheme.FontFamily.General,
                                            ),
                                            controller: user_password_check_text_field_controller,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.0,),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "* 입력되는 이름은 이후 다른 사용자가 유저를 식별할때 쓰이므로 정확한 이름을 입력해주세요.",
                                            style: TextStyle(
                                              color: Color(CtTheme.HexColor.Red),
                                              fontSize: CtTheme.FontSize.Small,
                                              fontFamily: CtTheme.FontFamily.General,
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
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.Middle),
                                                    ),
                                                  ),
                                                  backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Side1)),
                                                ),
                                                child: Text(
                                                  "뒤로",
                                                  style: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  spec_attend_church_page_view_controller.jumpToPage(0);
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
                                                  "등록",
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
                          SizedBox.expand(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(CtTheme.PaddingSize.Middle),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "교회 참가",
                                      style: TextStyle(
                                        color: Color(CtTheme.HexColor.Black),
                                        fontSize: CtTheme.FontSize.Big,
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
                                                  backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.Side1)),
                                                ),
                                                child: Text(
                                                  "뒤로",
                                                  style: TextStyle(
                                                    color: Color(CtTheme.HexColor.Black),
                                                    fontSize: CtTheme.FontSize.Middle,
                                                    fontFamily: CtTheme.FontFamily.General,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  spec_attend_church_page_view_controller.jumpToPage(0);
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
                                                  "참가",
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: CtTheme.Icon.Error(Color(CtTheme.HexColor.Black), CtTheme.IconSize.Middle),
            ),
          );
        }
        else{
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: CtTheme.Icon.Loading(Color(CtTheme.HexColor.Black)),
            ),
          );
        }
      },
    );
  }
}
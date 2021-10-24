import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'att_qrimage_page.dart';
import 'package:vof/my.dart';
import 'global_variable.dart';
import 'members_page.dart';

import 'att_qrimage_scanner_page.dart';
import '../lib/my.dart';
import '../lib/user_page.dart';
import '../lib/pointspec_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  DateTime today_datetime = new DateTime.now();

  bool is_button1_clicked = false;
  bool is_button2_clicked = false;
  bool is_button3_clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            leading: Builder(
                builder: (context) {
                  Widget _display_type = CtTheme.Icon.Student(Colors.black, 24.0);
                  if(tiny_db.getString("user_type") == "t"){
                    _display_type = CtTheme.Icon.Teacher(Colors.black, 24.0);
                  }
                  else if(tiny_db.getString("user_type") == "m"){
                    _display_type = CtTheme.Icon.Manager(Colors.black, 24.0);
                  }

                  return IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPage()),
                      );
                    },
                    icon: _display_type,
                  );
                }
            ),
            title: Text(
              "${tiny_db.getString("user_name")}님",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              Builder(
                builder: (context){
                  if(tiny_db.getString("user_type") != "s"){
                    return Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AttQrimageScannerPage()),
                            );
                          },
                          icon: Icon(Icons.qr_code_scanner_rounded),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MembersPage()),
                            );
                          },
                          icon: Icon(Icons.group_rounded),
                        ),
                      ],
                    );
                  }
                  else{
                    return SizedBox();
                  }
                }
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(CtTheme.PaddingSize.general),
                  child: SizedBox(
                    width: double.infinity,
                    height: 250.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.HexColor.primary)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(CtTheme.RadiusSize.general),
                            )),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PointspecPage(tiny_db.getString("user_email"), tiny_db.getString("user_type"), tiny_db.getString("user_name"), tiny_db.getInt("user_point"))),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "내 포인트",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: CtTheme.FontSize.general,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () async{
                                    await firestoreInstance.collection("users").doc(tiny_db.getString("user_email")).get().then(
                                            (value) {
                                          tiny_db.setInt("user_point", value["point"]);
                                        }
                                    );

                                    setState(() {});

                                    showDialog<String>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Text("새로고침 완료",
                                            style: TextStyle(
                                              fontSize: CtTheme.FontSize.general,
                                              color: Colors.black,
                                            ),),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, "확인"),
                                              child: Text("확인",
                                                style: TextStyle(
                                                  fontSize: CtTheme.FontSize.general,
                                                  color: Color(CtTheme.HexColor.primary),
                                                ),),
                                            ),
                                          ],
                                        )
                                    );
                                  },
                                  icon: Icon(
                                    Icons.cached,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${tiny_db.getInt("user_point")}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: CtTheme.FontSize.TooBig,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(width: 10.0,),
                                        CtTheme.Icon.Point(Colors.white, CtTheme.FontSize.TooBig),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextButton(
                                        onPressed: () async{
                                          EasyLoading.show(status: '로딩중...');

                                          if(is_button1_clicked == false){
                                            is_button1_clicked = true;
                                          }
                                          else{
                                            return;
                                          }

                                          List _db_qt_completion_dates = [];
                                          DateTime _today_datetime = new DateTime.now();
                                          Map<String, dynamic> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : _today_datetime.hour, "minute" : _today_datetime.minute};

                                          await firestoreInstance
                                              .collection("users")
                                              .doc(tiny_db.getString("user_email"))
                                              .get().then(
                                                  (value){
                                                _db_qt_completion_dates = value["qt_completion_dates"].cast<Map>();
                                              }
                                          );

                                          bool _is_contain = false;
                                          for(int i = 0; i<_db_qt_completion_dates.length; i++){
                                            Map<String, dynamic> _db_qt_completion_date = _db_qt_completion_dates[i];
                                            if((_db_qt_completion_date["day"] == _today_datemap["day"]) && (_db_qt_completion_date["month"] == _today_datemap["month"]) && (_db_qt_completion_date["year"] == _today_datemap["year"])){
                                              _is_contain = true;
                                              break;
                                            }
                                          }

                                          if(_is_contain){
                                            EasyLoading.dismiss();
                                            showDialog<String>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Text("오늘 이미 QT를 하셨습니다",
                                                        style: TextStyle(
                                                          fontSize: CtTheme.FontSize.general,
                                                          color: Colors.black,
                                                        ),),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context, "확인"),
                                                          child: Text("확인",
                                                            style: TextStyle(
                                                              fontSize: CtTheme.FontSize.general,
                                                              color: Color(CtTheme.HexColor.primary),
                                                            ),),
                                                        ),
                                                      ],
                                                    )
                                            );
                                          }
                                          else{
                                            int _plus_point = 0;
                                            int _db_user_point = 0;

                                            await firestoreInstance
                                                .collection("churches")
                                                .doc(tiny_db.getString("user_church_id"))
                                                .get().then(
                                                    (value){
                                                  _plus_point = value["qt_completion_point"];
                                                }
                                            );

                                            await firestoreInstance
                                                .collection("users")
                                                .doc(tiny_db.getString("user_email"))
                                                .get().then(
                                                    (value){
                                                  _db_user_point = value["point"];
                                                }
                                            );

                                            await firestoreInstance
                                                .collection("users")
                                                .doc(tiny_db.getString("user_email"))
                                                .update(
                                                {
                                                  "point" : _db_user_point + _plus_point,
                                                }
                                            );

                                            tiny_db.setInt("user_point", _db_user_point + _plus_point);

                                            _today_datemap["title"] = "QT 활동";
                                            _today_datemap["content"] = "승인 중에 있습니다";
                                            _today_datemap["plus_point"] = _plus_point;
                                            _today_datemap["type"] = "qt";
                                            _today_datemap["ok"] = false;
                                            _today_datemap["user_email"] = tiny_db.getString("user_email");
                                            _today_datemap["user_name"] = tiny_db.getString("user_name");
                                            _today_datemap["user_type"] = tiny_db.getString("user_type");

                                            _db_qt_completion_dates.add(_today_datemap);

                                            await firestoreInstance
                                                .collection("users")
                                                .doc(tiny_db.getString("user_email"))
                                                .update(
                                                {
                                                  "qt_completion_dates" : _db_qt_completion_dates,
                                                }
                                            );

                                            EasyLoading.dismiss();

                                            showDialog<String>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Text("앗싸! ${_plus_point} 포인트가 적립되었습니다",
                                                        style: TextStyle(
                                                          fontSize: CtTheme.FontSize.general,
                                                          color: Colors.black,
                                                        ),),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context, "확인"),
                                                          child: Text("확인",
                                                            style: TextStyle(
                                                              fontSize: CtTheme.FontSize.general,
                                                              color: Color(CtTheme.HexColor.primary),
                                                            ),),
                                                        ),
                                                      ],
                                                    )
                                            );

                                            setState(() {});
                                          }

                                          is_button1_clicked = false;
                                        },
                                        child: Text(
                                          "QT\n완료",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: CtTheme.FontSize.general,
                                          ),
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    child: VerticalDivider(
                                      thickness: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                        onPressed: () async{
                                          EasyLoading.show(status: '로딩중...');

                                          if(is_button2_clicked == false){
                                            is_button2_clicked = true;
                                          }
                                          else{
                                            return;
                                          }

                                          List _db_worship_completion_dates = [];
                                          DateTime _today_datetime = new DateTime.now();
                                          Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : _today_datetime.hour, "minute" : _today_datetime.minute};

                                          await firestoreInstance
                                              .collection("users")
                                              .doc(tiny_db.getString("user_email"))
                                              .get().then(
                                                  (value){
                                                _db_worship_completion_dates = value["worship_completion_dates"].cast<Map>();
                                              }
                                          );

                                          bool _is_contain = false;
                                          for(int i = 0; i<_db_worship_completion_dates.length; i++){
                                            Map<String, dynamic> _db_worship_completion_date = _db_worship_completion_dates[i];
                                            if((_db_worship_completion_date["day"] == _today_datemap["day"]) && (_db_worship_completion_date["month"] == _today_datemap["month"]) && (_db_worship_completion_date["year"] == _today_datemap["year"])){
                                              _is_contain = true;
                                              break;
                                            }
                                          }

                                          if(_is_contain){
                                            EasyLoading.dismiss();

                                            showDialog<String>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Text("오늘 이미 예배에 출석하셨습니다",
                                                        style: TextStyle(
                                                          fontSize: CtTheme.FontSize.general,
                                                          color: Colors.black,
                                                        ),),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context, "확인"),
                                                          child: Text("확인",
                                                            style: TextStyle(
                                                              fontSize: CtTheme.FontSize.general,
                                                              color: Color(CtTheme.HexColor.primary),
                                                            ),),
                                                        ),
                                                      ],
                                                    )
                                            );
                                          }
                                          else {
                                            EasyLoading.dismiss();

                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>
                                                  AttQrimagePage(
                                                      QrImage(
                                                        data: tiny_db.getString(
                                                            "user_email"),
                                                        backgroundColor: Colors.white,
                                                        size: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width - 40,
                                                      )
                                                  )
                                              ),
                                            );

                                            int _db_user_point = 0;

                                            await firestoreInstance
                                                .collection("users")
                                                .doc(tiny_db.getString("user_email"))
                                                .get().then(
                                                    (value){
                                                  _db_user_point = value["point"];
                                                }
                                            );

                                            tiny_db.setInt("user_point", _db_user_point);

                                            setState(() {});
                                          }

                                          is_button2_clicked = false;
                                        },
                                        child: Text(
                                          "예배\n기도회",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: CtTheme.FontSize.general,
                                          ),
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    child: VerticalDivider(
                                      thickness: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async{
                                        EasyLoading.show(status: '로딩중...');

                                        if(is_button3_clicked == false){
                                          is_button3_clicked = true;
                                        }
                                        else{
                                          return;
                                        }

                                        if(today_datetime.weekday != 7){
                                          EasyLoading.dismiss();

                                          showDialog<String>(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    content: Text("주일이 아닙니다",
                                                      style: TextStyle(
                                                        fontSize: CtTheme.FontSize.general,
                                                        color: Colors.black,
                                                      ),),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(context, "확인"),
                                                        child: Text("확인",
                                                          style: TextStyle(
                                                            fontSize: CtTheme.FontSize.general,
                                                            color: Color(CtTheme.HexColor.primary),
                                                          ),),
                                                      ),
                                                    ],
                                                  )
                                          );

                                          return;
                                        }

                                        List _db_worship_write_completion_dates = [];
                                        DateTime _today_datetime = new DateTime.now();
                                        Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : _today_datetime.hour, "minute" : _today_datetime.minute};

                                        await firestoreInstance
                                            .collection("users")
                                            .doc(tiny_db.getString("user_email"))
                                            .get().then(
                                                (value){
                                              _db_worship_write_completion_dates = value["worship_write_completion_dates"].cast<Map>();
                                            }
                                        );

                                        bool _is_contain = false;
                                        for(int i = 0; i<_db_worship_write_completion_dates.length; i++){
                                          Map<String, dynamic> _db_worship_write_completion_date = _db_worship_write_completion_dates[i];
                                          if((_db_worship_write_completion_date["day"] == _today_datemap["day"]) && (_db_worship_write_completion_date["month"] == _today_datemap["month"]) && (_db_worship_write_completion_date["year"] == _today_datemap["year"])){
                                            _is_contain = true;
                                            break;
                                          }
                                        }

                                        if(_is_contain){
                                          EasyLoading.dismiss();

                                          showDialog<String>(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    content: Text("오늘 이미 설교를 메모하셨습니다",
                                                      style: TextStyle(
                                                        fontSize: CtTheme.FontSize.general,
                                                        color: Colors.black,
                                                      ),),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(context, "확인"),
                                                        child: Text("확인",
                                                          style: TextStyle(
                                                            fontSize: CtTheme.FontSize.general,
                                                            color: Color(CtTheme.HexColor.primary),
                                                          ),),
                                                      ),
                                                    ],
                                                  )
                                          );
                                        }
                                        else{
                                          int _plus_point = 0;
                                          int _db_user_point = 0;

                                          await firestoreInstance
                                              .collection("churches")
                                              .doc(tiny_db.getString("user_church_id"))
                                              .get().then(
                                                  (value){
                                                _plus_point = value["worship_write_completion_point"];
                                              }
                                          );

                                          await firestoreInstance
                                              .collection("users")
                                              .doc(tiny_db.getString("user_email"))
                                              .get().then(
                                                  (value){
                                                _db_user_point = value["point"];
                                              }
                                          );

                                          await firestoreInstance
                                              .collection("users")
                                              .doc(tiny_db.getString("user_email"))
                                              .update(
                                              {
                                                "point" : _db_user_point + _plus_point,
                                              }
                                          );

                                          tiny_db.setInt("user_point", _db_user_point + _plus_point);

                                          _db_worship_write_completion_dates.add(_today_datemap);

                                          await firestoreInstance
                                              .collection("users")
                                              .doc(tiny_db.getString("user_email"))
                                              .update(
                                              {
                                                "worship_write_completion_dates" : _db_worship_write_completion_dates,
                                              }
                                          );

                                          EasyLoading.dismiss();

                                          showDialog<String>(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    content: Text("앗싸! ${_plus_point} 포인트가 적립되었습니다",
                                                      style: TextStyle(
                                                        fontSize: CtTheme.FontSize.general,
                                                        color: Colors.black,
                                                      ),),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(context, "확인"),
                                                        child: Text("확인",
                                                          style: TextStyle(
                                                            fontSize: CtTheme.FontSize.general,
                                                            color: Color(CtTheme.HexColor.primary),
                                                          ),),
                                                      ),
                                                    ],
                                                  )
                                          );

                                          setState(() {});
                                        }

                                        is_button3_clicked = false;
                                      },
                                      child: Text(
                                        "설교\n메모",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: CtTheme.FontSize.general,
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
                  ),
                ),
                SizedBox(height: CtTheme.PaddingSize.general,),
                Container(
                  width: double.infinity,
                  height: 700.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(CtTheme.RadiusSize.general*2),
                      topRight: Radius.circular(CtTheme.RadiusSize.general*2),
                    ),
                    color: Color(0xfff8f9fa),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 4,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Top 5",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: CtTheme.FontSize.general,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            future: firestoreInstance.collection("users").where("church_id", isEqualTo: tiny_db.getString("user_church_id")).orderBy("point", descending: true).limit(10).get().then((value) => value),
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                return SizedBox(
                                  width: double.infinity,
                                  height: 620.0,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.size,
                                    itemBuilder: (context, index){
                                      dynamic _user = snapshot.data!.docs[index];

                                      return Column(
                                        children: <Widget>[
                                          Builder(
                                              builder: (context) {
                                                if(index == 0){
                                                  return SizedBox();
                                                }
                                                else{
                                                  return SizedBox(height: 20.0,);
                                                }
                                              }
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 100.0,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.resolveWith(
                                                      (states) {
                                                    return states.contains(MaterialState.pressed)
                                                        ? Color(CtTheme.HexColor.secondary)
                                                        : null;
                                                  },
                                                ),
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(CtTheme.RadiusSize.general),
                                                    )),
                                              ),
                                              onPressed: () async{
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => PointspecPage(_user["email"], _user["type"], _user["name"], _user["point"])),
                                                );

                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "${index+1}등",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: CtTheme.FontSize.TooBig,
                                                      ),
                                                    ),
                                                    SizedBox(width: 20.0,),
                                                    Builder(
                                                        builder: (context) {
                                                          Widget _display_type = CtTheme.Icon.Student(Colors.black, 24.0);
                                                          if(_user["type"] == "t"){
                                                            _display_type = CtTheme.Icon.Teacher(Colors.black, 24.0);
                                                          }
                                                          else if(_user["type"] == "m"){
                                                            _display_type = CtTheme.Icon.Manager(Colors.black, 24.0);
                                                          }

                                                          return _display_type;
                                                        }
                                                    ),
                                                    SizedBox(width: 10.0,),
                                                    Text(
                                                      "${_user["name"]}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: CtTheme.FontSize.general,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
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
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ]
      )
    );
  }
}
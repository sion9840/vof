import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vof/att_qrimage_page.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';
import 'package:vof/members_page.dart';

import 'att_qrimage_scanner_page.dart';
import 'user_page.dart';
import 'pointspec_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  DateTime today_datetime = new DateTime.now();

  String input_user_church_id = "";
  String input_user_password = "";

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
            automaticallyImplyLeading: false,
            title: Text(
              "${tiny_db.getString("user_name")}님",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              Builder(
                builder: (context){
                  if((tiny_db.getString("user_type") == "t") && (tiny_db.getString("user_church_id") != "")){
                    return Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AttQrimageScannerPage()),
                            );
                          },
                          icon: Icon(Icons.scanner),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MembersPage()),
                            );
                          },
                          icon: Icon(Icons.group),
                        )
                      ],
                    );
                  }
                  else{
                    return SizedBox();
                  }
                }
              ),
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPage()),
                  );
                },
                icon: Icon(Icons.account_circle),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Builder(
              builder: (context){
                if(tiny_db.getString("user_church_id") == ""){
                  return goChurchView(context);
                }
                else{
                  return mainView(context);
                }
              },
            ),
          ),
        ]
      )
    );
  }

  Widget goChurchView(context){
    return Padding(
      padding: EdgeInsets.all(CtTheme.CtPaddingSize.general),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      content: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "교회 아이디",
                        ),
                        onChanged: (value) {
                          input_user_church_id = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async{
                            if(input_user_church_id != "SdbGa9"){
                              showDialog<String>(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(
                                        content: const Text("존재하지 않는 교회 아이디 입니다"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, "확인"),
                                            child: const Text("확인"),
                                          ),
                                        ],
                                      )
                              );
                            }
                            else{
                              List<String> _members = [];

                              String _db_type_tag = "students";
                              if(tiny_db.getString("user_type") == "t"){
                                _db_type_tag = "teachers";
                              }

                              await firestoreInstance
                                  .collection("churches")
                                  .doc(input_user_church_id)
                                  .get().then(
                                  (value){
                                    _members = value[_db_type_tag].cast<String>();
                                  }
                              );

                              _members.add(tiny_db.getString("user_email"));

                              await firestoreInstance
                                  .collection("churches")
                                  .doc(input_user_church_id)
                                  .update(
                                  {
                                    _db_type_tag : _members,
                                  }
                              );

                              await firestoreInstance
                                  .collection("users")
                                  .doc(tiny_db.getString("user_email"))
                                  .update(
                                  {
                                    "church_id" : input_user_church_id,
                                  }
                              );

                              tiny_db.setString("user_church_id", input_user_church_id);

                              Navigator.pop(context, "확인");
                              setState(() {});
                            }
                          },
                          child: const Text("확인"),
                        ),
                        TextButton(
                          onPressed: () {
                            input_user_church_id = "";
                            Navigator.pop(context, "취소");
                          },
                          child: const Text("취소"),
                        ),
                      ],
                    );
                  }
              );
            },
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                border: Border.all(
                  color: Color(CtTheme.CtHexColor.primary),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  "교회 추가",
                  style: TextStyle(
                    color: Color(CtTheme.CtHexColor.primary),
                    fontSize: CtTheme.CtTextSize.general,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainView(context){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(CtTheme.CtPaddingSize.general),
          child: OpenContainer(
            openBuilder: (_, closeContainer){
              return PointspecPage(tiny_db.getString("user_email"), tiny_db.getString("user_type"), "", tiny_db.getInt("user_point"));
            },
            closedBuilder: (_, openContainer){
              return Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                  color: Color(CtTheme.CtHexColor.primary),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
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
                              fontSize: CtTheme.CtTextSize.general,
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
                                    content: const Text("새로고침 완료"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, "확인"),
                                        child: const Text("확인"),
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
                          child: Center(
                            child: Text(
                              "${tiny_db.getInt("user_point")} 포인트",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CtTheme.CtTextSize.general,
                              ),
                            ),
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
                                    List _db_qt_completion_dates = [];
                                    DateTime _today_datetime = new DateTime.now();
                                    Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : int.parse(DateFormat("ss").format(_today_datetime)), "minute" : _today_datetime.minute};

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
                                      showDialog<String>(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                content: const Text("오늘 이미 QT를 하셨습니다"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, "확인"),
                                                    child: const Text("확인"),
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

                                      _db_qt_completion_dates.add(_today_datemap);

                                      await firestoreInstance
                                          .collection("users")
                                          .doc(tiny_db.getString("user_email"))
                                          .update(
                                          {
                                            "qt_completion_dates" : _db_qt_completion_dates,
                                          }
                                      );

                                      showDialog<String>(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                content: Text("앗싸! ${_plus_point} 포인트가 적립되었습니다"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, "확인"),
                                                    child: const Text("확인"),
                                                  ),
                                                ],
                                              )
                                      );

                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    "QT완료",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: CtTheme.CtTextSize.small,
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
                                    List _db_worship_completion_dates = [];
                                    DateTime _today_datetime = new DateTime.now();
                                    Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : int.parse(DateFormat("ss").format(_today_datetime)), "minute" : _today_datetime.minute};

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
                                      showDialog<String>(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                content: Text("오늘 이미 예배에 출석하셨습니다"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, "확인"),
                                                    child: const Text("확인"),
                                                  ),
                                                ],
                                              )
                                      );
                                    }
                                    else {
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
                                  },
                                  child: Text(
                                    "예배&기도회 출석",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: CtTheme.CtTextSize.small,
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
                                  if(today_datetime.weekday != 7){
                                    showDialog<String>(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              content: const Text("주일이 아닙니다"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, "확인"),
                                                  child: const Text("확인"),
                                                ),
                                              ],
                                            )
                                    );

                                    return;
                                  }

                                  List _db_worship_write_completion_dates = [];
                                  DateTime _today_datetime = new DateTime.now();
                                  Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : int.parse(DateFormat("ss").format(_today_datetime)), "minute" : _today_datetime.minute};

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
                                    showDialog<String>(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              content: const Text("오늘 이미 설교를 메모하셨습니다"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, "확인"),
                                                  child: const Text("확인"),
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

                                    showDialog<String>(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              content: Text("앗싸! ${_plus_point} 포인트가 적립되었습니다"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, "확인"),
                                                  child: const Text("확인"),
                                                ),
                                              ],
                                            )
                                    );

                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  "설교메모완료",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: CtTheme.CtTextSize.small,
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
              );
            },
          ),
        ),
        SizedBox(height: 30.0,),
        Container(
          width: double.infinity,
          height: 660.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(CtTheme.CtRadiusSize.general*2),
              topRight: Radius.circular(CtTheme.CtRadiusSize.general*2),
            ),
            color: Color(0xfff8f9fa),
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 4,
                offset: Offset(0, -2),
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
                          fontSize: CtTheme.CtTextSize.general,
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
                        height: 580.0,
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
                                  InkWell(
                                    onTap: () async{
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PointspecPage(_user["email"], _user["type"], _user["name"], _user["point"])),
                                      );

                                      setState(() {});
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(CtTheme.CtRadiusSize.general),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "${index+1}등",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: CtTheme.CtTextSize.big,
                                              ),
                                            ),
                                            SizedBox(width: 20.0,),
                                            Text(
                                              "${_user["name"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: CtTheme.CtTextSize.general,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "${_user["point"]} 포인트",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: CtTheme.CtTextSize.general,
                                              ),
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
    );
  }
}
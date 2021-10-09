import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

import 'custom_theme.dart';

class AttQrimageScannerPage extends StatefulWidget {
  @override
  _AttQrimageScannerPageState createState() => _AttQrimageScannerPageState();
}

class _AttQrimageScannerPageState extends State<AttQrimageScannerPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String notice = "";

  List<String> korea_weekday_names = ["월", "화", "수", "목", "금", "토", "일"];
  List<String> worship_weekday_names = ["기도회", "기도회", "기도회", "기도회", "기도회", "기도회", "예배"];
  DateTime today_datetime = new DateTime.now();

  String input_email = "";

  @override
  Widget build(BuildContext context) {
    return isWeb();
  }

  Widget isWeb(){
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("${worship_weekday_names[today_datetime.weekday-1]} 참석"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.input),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text(
                        "수동 입력 참석",
                        style: TextStyle(
                          fontSize: CtTheme.CtTextSize.general,
                          color: Colors.black,
                        ),
                      ),
                      content: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "구성원 이메일",
                        ),
                        onChanged: (value) {
                          input_email = value.trim();
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            input_email = "";
                            Navigator.pop(context, "취소");
                          },
                          child: Text("취소",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                        TextButton(
                          onPressed: () async{
                            await cal_check(input_email);
                          },
                          child: Text("확인",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                      ],
                    );
                  }
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  "VOF 포인트의 웹 버전은 QR코드 스캐너가 지원되지 않습니다\n안드로이드 앱 혹은 수동 입력 참석 기능을 이용해주세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: CtTheme.CtTextSize.general,
                    color: Colors.black
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: Center(
              child: Text(
                notice,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget isNotWeb(){
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("${worship_weekday_names[today_datetime.weekday-1]} 참석"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.flip_camera_android),
            onPressed: (){
              this.controller!.flipCamera();
            },
          ),
          IconButton(
            icon: Icon(Icons.input),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text(
                        "수동 입력 참석",
                        style: TextStyle(
                          fontSize: CtTheme.CtTextSize.general,
                          color: Colors.black,
                        ),
                      ),
                      content: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "구성원 이메일",
                        ),
                        onChanged: (value) {
                          input_email = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            input_email = "";
                            Navigator.pop(context, "취소");
                          },
                          child: Text("취소",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                        TextButton(
                          onPressed: () async{
                            await cal_check(input_email);
                          },
                          child: Text("확인",
                            style: TextStyle(
                              fontSize: CtTheme.CtTextSize.general,
                              color: Color(CtTheme.CtHexColor.primary),
                            ),),
                        ),
                      ],
                    );
                  }
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Builder(
                builder: (context) {
                  var scanArea = (MediaQuery.of(context).size.width < 400 ||
                      MediaQuery.of(context).size.height < 400)
                      ? 150.0
                      : 300.0;

                  return QRView(
                    key: qrKey,
                    onQRViewCreated: onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        borderColor: Color(CtTheme.CtHexColor.primary),
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: scanArea),
                  );
                }
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: Center(
              child: Text(
                notice,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CtTheme.CtTextSize.general,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) async{
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async{
      await cal_check(scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void flipCamera() async{
    await controller!.flipCamera();
  }

  Future cal_check(data) async{
    String _data = data;

    List<String> _members = [];

    await firestoreInstance
        .collection("churches")
        .doc(tiny_db.getString("user_church_id"))
        .get().then(
            (value){
          _members = new List.from(value["students"].cast<String>())..addAll(value["teachers"].cast<String>());
        }
    );

    if(_members.contains(_data) == false){
      notice = "예배출석 QR코드가 아닙니다";
      setState(() {});
    }
    else{
      String _db_user_name = "";
      int _db_user_point = 0;
      int _plus_point = 0;
      List _worship_completion_dates = [];
      DateTime _today_datetime = new DateTime.now();
      Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : _today_datetime.hour, "minute" : _today_datetime.minute};

      await firestoreInstance
          .collection("users")
          .doc(_data)
          .get().then(
              (value){
            _worship_completion_dates = value["worship_completion_dates"].cast<Map>();
            _db_user_point = value["point"];
            _db_user_name = value["name"];
          }
      );

      bool _is_contain = false;
      for(int i = 0; i<_worship_completion_dates.length; i++){
        Map<String, dynamic> _worship_completion_date = _worship_completion_dates[i];
        if((_worship_completion_date["day"] == _today_datemap["day"]) && (_worship_completion_date["month"] == _today_datemap["month"]) && (_worship_completion_date["year"] == _today_datemap["year"])){
          _is_contain = true;
          break;
        }
      }

      if(_is_contain){
        notice = "${_db_user_name}님이 ${worship_weekday_names[today_datetime.weekday-1]}에 출석하셨습니다";
        setState(() {});
      }
      else{
        _worship_completion_dates.add(_today_datemap);

        await firestoreInstance
            .collection("users")
            .doc(_data)
            .update(
            {
              "worship_completion_dates" : _worship_completion_dates,
            }
        );

        if(_today_datetime.weekday != 7){
          bool _get_complete_multi_special_worship = false;

          Map<String, dynamic> _worship_completion_date = _worship_completion_dates[0];
          DateTime _thatday_datetime = new DateTime(
              _worship_completion_date["year"],
              _worship_completion_date["month"],
              _worship_completion_date["day"],
              0,
              0,
              0,
              0,
              0
          );

          bool _is_multi_worship_completion_point = false;

          await firestoreInstance
              .collection("churches")
              .doc(tiny_db.getString("user_church_id"))
              .get()
              .then(
                  (value){
                _is_multi_worship_completion_point = value["is_multi_worship_completion_point"];
              }
          );

          if((_today_datetime.compareTo(_thatday_datetime) < _today_datetime.weekday) && (_is_multi_worship_completion_point == false)){
            notice = "${_db_user_name}님이 ${worship_weekday_names[today_datetime.weekday-1]}에 출석하셨습니다\n(이번주에 이미 기도회를 참석하셨기에 포인트가 지급되어지지 않습니다)";
            setState(() {});
          }
          else{
            await firestoreInstance
                .collection("churches")
                .doc(tiny_db.getString("user_church_id"))
                .get().then(
                    (value){
                  _plus_point = value["worship_completion_points"][korea_weekday_names[_today_datetime.weekday-1] as String];
                }
            );

            await firestoreInstance
                .collection("users")
                .doc(_data)
                .update(
                {
                  "point" : _db_user_point + _plus_point,
                }
            );

            notice = "${_db_user_name}님이 ${worship_weekday_names[today_datetime.weekday-1]}에 출석하셨습니다";
            setState(() {});
          }
        }
        else{
          await firestoreInstance
              .collection("churches")
              .doc(tiny_db.getString("user_church_id"))
              .get().then(
                  (value){
                _plus_point = value["worship_completion_points"][korea_weekday_names[_today_datetime.weekday-1] as String];
              }
          );

          await firestoreInstance
              .collection("users")
              .doc(_data)
              .update(
              {
                "point" : _db_user_point + _plus_point,
              }
          );

          notice = "${_db_user_name}님이 ${worship_weekday_names[today_datetime.weekday-1]}에 출석하셨습니다";
          setState(() {});
        }
      }
    }
  }
}

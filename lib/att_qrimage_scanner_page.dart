import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

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
  DateTime today_datetime = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("${korea_weekday_names[today_datetime.weekday]}요예배 참석"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.flip_camera_android),
            onPressed: (){
              this.controller!.flipCamera();
            },
          )
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
      String _data = scanData.code;

      List<String> _students = [];

      await firestoreInstance
          .collection("churches")
          .doc(tiny_db.getString("user_church_id"))
          .get().then(
          (value){
            _students = value["students"].cast<String>();
          }
      );

      if(_students.contains(_data) == false){
        setState(() {
          notice = "예배참석 QR코드가 아닙니다";
        });
      }
      else{
        String _db_user_name = "";
        int _db_user_point = 0;
        int _plus_point = 0;
        List _worship_completion_dates = [];
        DateTime _today_datetime = new DateTime.now();
        Map<String, int> _today_datemap = {"year" : _today_datetime.year, "month" : _today_datetime.month, "day" : _today_datetime.day, "hour" : int.parse(DateFormat("ss").format(_today_datetime)), "minute" : _today_datetime.minute};

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
          setState(() {
            notice = "${_db_user_name}님이 ${korea_weekday_names[today_datetime.weekday]}요예배에 출석하셨습니다";
          });
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

          if(_today_datetime.weekday != 6){
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

            if(_today_datetime.compareTo(_thatday_datetime) < (1 + _today_datetime.weekday)){
              setState(() {
                notice = "${_db_user_name}님이 ${korea_weekday_names[_today_datetime.weekday]}요예배에 출석하셨습니다\n(이번주에 이미 특별예배를 참석하셨기에 포인트가 지급되어지지 않습니다)";
              });
            }
            else{
              await firestoreInstance
                  .collection("churches")
                  .doc(tiny_db.getString("user_church_id"))
                  .get().then(
                      (value){
                    _plus_point = value["worship_completion_points"][korea_weekday_names[_today_datetime.weekday]];
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

              setState(() {
                notice = "${_db_user_name}님이 ${korea_weekday_names[today_datetime.weekday]}요예배에 출석하셨습니다";
              });
            }
          }
          else{
            await firestoreInstance
                .collection("churches")
                .doc(tiny_db.getString("user_church_id"))
                .get().then(
                    (value){
                  _plus_point = value["worship_completion_points"][korea_weekday_names[_today_datetime.weekday]];
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

            setState(() {
              notice = "${_db_user_name}님이 ${korea_weekday_names[today_datetime.weekday]}요예배에 출석하셨습니다";
            });
          }
        }
      }
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
}
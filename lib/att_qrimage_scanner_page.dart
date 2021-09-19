import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vof/global_variable.dart';

class AttQrimageScannerPage extends StatefulWidget {
  @override
  _AttQrimageScannerPageState createState() => _AttQrimageScannerPageState();
}

class _AttQrimageScannerPageState extends State<AttQrimageScannerPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("예배 참석 QR코드 스캐너"),
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
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: scanArea),
                  onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  void onQRViewCreated(QRViewController controller) {
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
        showDialog<String>(
            context: context,
            builder: (context) =>
                AlertDialog(
                  content: Text("예배 출석 QR코드가 아닙니다"),
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
        int _db_user_point = 0;
        int _plus_point = 0;
        List<String> _worship_completion_dates = [];
        DateTime _today_datetime = new DateTime.now();
        String _today_datestring ="${_today_datetime.year.toString()}-${_today_datetime.month.toString().padLeft(2,'0')}-${_today_datetime.day.toString().padLeft(2,'0')}";

        await firestoreInstance
            .collection("users")
            .doc(_data)
            .get().then(
                (value){
              _worship_completion_dates = value["worship_completion_dates"].cast<String>();
              _db_user_point = value["point"];
            }
        );

        if(_worship_completion_dates.contains(_today_datestring)){
          showDialog<String>(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    content: Text("오늘 이미 예배에 참석하셨습니다"),
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
          await firestoreInstance
              .collection("churches")
              .doc(tiny_db.getString("user_church_id"))
              .get().then(
                  (value){
                _plus_point = value["worship_completion_point"];
              }
          );

          _worship_completion_dates.add(_today_datestring);

          await firestoreInstance
              .collection("users")
              .doc(_data)
              .update(
              {
                "point" : _db_user_point + _plus_point,
                "worship_completion_dates" : _worship_completion_dates,
              }
          );

          showDialog<String>(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    content: Text("예배 출석이 완료되었습니다"),
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
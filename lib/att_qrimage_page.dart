import 'package:flutter/material.dart';

class AttQrimagePage extends StatelessWidget {
  dynamic _att_qrimage;
  AttQrimagePage(dynamic att_qrimage){
    _att_qrimage = att_qrimage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("교회 출석 QR코드"),
      ),
      body: Center(
        child: _att_qrimage,
      ),
    );
  }
}
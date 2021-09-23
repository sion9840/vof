import 'package:flutter/material.dart';

class AttQrimagePage extends StatelessWidget {
  dynamic att_qrimage;
  AttQrimagePage(dynamic _att_qrimage){
    att_qrimage = _att_qrimage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
      ),
      body: Center(
        child: att_qrimage,
      ),
    );
  }
}
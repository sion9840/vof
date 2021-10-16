import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var ClientDbInstance;
final FirestoreInstance = FirebaseFirestore.instance;

class CtTheme {
  static _HexColor HexColor = _HexColor();
  static _PaddingSize PaddingSize = _PaddingSize();
  static _RadiusSize RadiusSize = _RadiusSize();
  static _FontSize FontSize = _FontSize();
  static _IconSize IconSize = _IconSize();
  static _Icon Icon = _Icon();
  static _FontFamily FontFamily = _FontFamily();
}

class _HexColor {
  int Primary1 = 0xFF92B8FF;
  int Primary2 = 0xFF5E91F2;
  int Primary3 = 0xFF1564BF;
  int Primary4 = 0xFF003B8E;
  int Background = 0xFFF2F2F2;
  int Black = 0xFF121212;
  int White = 0xFFFFFFFF;
  int Side = 0xFFC0C0C0;
}

class _PaddingSize {
  double Middle = 20.0;
}

class _RadiusSize {
  double Middle = 12.0;
}

class _FontSize {
  double Small = 12.0;
  double Middle = 18.0;
  double Big = 24.0;
  double TooBig =36.0;
}

class _IconSize {
  double Middle = 24.0;
}

class _Icon {
  Widget Student(Color color, double size){
    return Icon(
      Icons.school_rounded,
      color: color,
      size: size,
    );
  }
  Widget Teacher(Color color, double size){
    return Icon(
      Icons.cast_for_education_rounded,
      color: color,
      size: size,
    );
  }
  Widget Manager(Color color, double size){
    return Icon(
      Icons.manage_accounts_rounded,
      color: color,
      size: size,
    );
  }
  Widget Point(Color color, double size){
    return Icon(
      Icons.toll_rounded,
      color: color,
      size: size,
    );
  }
  Widget Error(Color color, double size){
    return Icon(
      Icons.error_rounded,
      color: color,
      size: size,
    );
  }
  Widget Loading(Color color){
    return CircularProgressIndicator(
      color: color,
    );
  }
}

class _FontFamily {
  String General = "General";
  String Bold = "Bold";
}
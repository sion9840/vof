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
  int Primary1 = 0xFF228BE6;
  int Primary2 = 0xFF1C7ED6;
  int Primary3 = 0xFF1971C2;
  int Primary4 = 0xFF1864AB;
  int Background = 0xFFF8F9FA;
  int Black = 0xFF343A40;
  int White = 0xFFFFFFFF;
  int Side = 0xFF495057;
}

class _PaddingSize {
  double Middle = 20.0;
}

class _RadiusSize {
  double Middle = 12.0;
  double Big = 24.0;
}

class _FontSize {
  double Small = 18.0;
  double Middle = 24.0;
  double Big = 30.0;
  double TooBig = 45.0;
}

class _IconSize {
  double Middle = 30.0;
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
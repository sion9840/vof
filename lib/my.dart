import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'my.g.dart';

var TinyDb;
final FirestoreInstance = FirebaseFirestore.instance;

@HiveType(typeId : 1)
class Unit{
  @HiveField(0)
  String id;
  @HiveField(1)
  String type;
  @HiveField(2)
  String user_id;
  @HiveField(3)
  bool okay;
  @HiveField(4)
  Map<String, int> date;
  @HiveField(5)
  String title;
  @HiveField(6)
  String content;

  Unit({required this.id, required this.type, required this.user_id, required this.okay, required this.date, required this.title, required this.content});
}

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
  int Primary1 = 0xFFffe066;
  int Primary2 = 0xFFF59F00;
  int Background = 0xFFF8FAFC;
  int Black = 0xFF000000;
  int White = 0xFFFFFFFF;
  int Side1 = 0xFFE9EDF1;
  int Side2 = 0xFFCAD4DD;
  int Red = 0xFFE08C8D;
  int Green = 0xFFBADFDE;
}

class _PaddingSize {
  double Middle = 20.0;
}

class _RadiusSize {
  double Small = 4.0;
  double Middle = 9.0;
  double Big = 18.0;
}

class _FontSize {
  double Small = 14.0;
  double Middle = 17.0;
  double Big = 24.0;
  double TooBig = 28.0;
}

class _IconSize {
  double Middle = 33.0;
  double Big = 60.0;
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
  Widget Account(Color color, double size){
    return Icon(
      Icons.account_circle_rounded,
      color: color,
      size: size,
    );
  }
}

class _FontFamily {
  String General = "General";
  String Bold = "Bold";
}
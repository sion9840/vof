import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var ClientDbInstance;
final FirestoreInstance = FirebaseFirestore.instance;

class DataBase{
  var fixed_database;

  Future<Database> get fixedDatabase async {
    if(fixed_database != null) return fixed_database;

    fixed_database = openDatabase(
      join(await getDatabasesPath(), "fixed_database.db"),
      onCreate: (db, version) => createTable(db),
      version: 1,
    );

    return fixed_database;
  }

  void createTable(Database db) {
    db.execute(
        "CREATE TABLE user (id TEXT, church_id TEXT, units TEXT)"
    );
  }

  Future<void> insertUserModel(UserModel userModel) async {
    final db = await fixed_database;

    await db.insert(
      "user",
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class UserModel {
  late String id;
  late String church_id;
  late List<String> units;

  UserModel({required this.id, required this.church_id, required this.units});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id" : id,
      "church_id" : church_id,
      "units" : units,
    };
  }
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
  int Primary1 = 0xFF649BED;
  int Primary2 = 0xFF196BE5;
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
  double Big = 28.0;
}

class _IconSize {
  double Middle = 33.0;
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
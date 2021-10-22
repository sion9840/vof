import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var TinyDb;
final FirestoreInstance = FirebaseFirestore.instance;

class DataBase{
  var _fixed_database;

  Future<Database> get fixed_database async {
    if(_fixed_database != null) return _fixed_database;

    _fixed_database = openDatabase(
      join(await getDatabasesPath(), "fixed_database.db"),
      onCreate: (db, version) => createTable(db),
      version: 1,
    );

    return _fixed_database;
  }

  void createTable(Database db) async {
    db.execute(
        "CREATE TABLE user (unit TEXT)"
    );
  }

  Future<void> insertUserModel(UserModel userModel) async {
    final db = await _fixed_database;

    await db.insert(
      "user",
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel> getUserModel() async {
    final db = await _fixed_database;

    final List<Map<String, dynamic>> maps = await db.query("user");

    return UserModel(
      unit: maps[0]["unit"],
    );
  }

  Future<void> deleteUser() async{
    final db = await _fixed_database;

    await db.delete(
      "user"
    );
  }

  Future<void> updateUserModel(UserModel userModel) async {
    final db = await _fixed_database;

    await db.update(
      'user',
      userModel.toMap(),
      where: "unit = ?",
      whereArgs: [0],
    );
  }
}

class UserModel {
  late String unit;

  UserModel({required this.unit});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "units" : unit,
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
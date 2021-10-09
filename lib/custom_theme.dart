import 'package:flutter/material.dart';

class CtTheme {
  static nCtHexColor CtHexColor = nCtHexColor();
  static nCtPaddingSize CtPaddingSize = nCtPaddingSize();
  static nCtRadiusSize CtRadiusSize = nCtRadiusSize();
  static nCtTextSize CtTextSize = nCtTextSize();
  static nCtIcon CtIcon = nCtIcon();
}

class nCtHexColor {
  int primary = 0xFF4c6ef5;
  int secondary = 0xFFedf2ff;
}

class nCtPaddingSize {
  double general = 20;
}

class nCtRadiusSize {
  double general = 12;
}

class nCtTextSize {
  double small = 12;
  double general = 18;
  double big = 24;
  double too_big =36;
}

class nCtIcon {
  Widget student(Color color, double size){
    return Icon(
      Icons.school_rounded,
      color: color,
      size: size,
    );
  }
  Widget teacher(Color color, double size){
    return Icon(
      Icons.cast_for_education_rounded,
      color: color,
      size: size,
    );
  }
  Widget manager(Color color, double size){
    return Icon(
      Icons.manage_accounts_rounded,
      color: color,
      size: size,
    );
  }
  Widget point(Color color, double size){
    return Icon(
      Icons.toll_rounded,
      color: color,
      size: size,
    );
  }
}
import 'package:flutter/material.dart';
class AppTheme {
  static const primary=Color(0xFF087D70);
  static const secondary=Color(0xFF18B49D);
  static const background=Color(0xFFF2F8F6);
  static ThemeData get lightTheme => ThemeData(
    useMaterial3:true,
    colorScheme:ColorScheme.fromSeed(seedColor:primary,primary:primary,secondary:secondary,surface:Colors.white),
    scaffoldBackgroundColor:background,
    appBarTheme:const AppBarTheme(backgroundColor:background,foregroundColor:Color(0xFF173D38),elevation:0),
    cardTheme:CardThemeData(color:Colors.white,elevation:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))),
    inputDecorationTheme:InputDecorationTheme(border:OutlineInputBorder(borderRadius:BorderRadius.circular(12))),
    filledButtonTheme:FilledButtonThemeData(style:FilledButton.styleFrom(padding:const EdgeInsets.symmetric(horizontal:22,vertical:18),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14)))),
  );
}

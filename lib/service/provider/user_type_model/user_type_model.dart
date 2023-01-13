import 'package:flutter/material.dart';

class UserTypeModel extends ChangeNotifier{
  String value = "";

  String valRead() => value;

  void valChange(String val){
    value = val;
    notifyListeners();
  }
}
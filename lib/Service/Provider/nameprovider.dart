import 'package:flutter/material.dart';

class UserNameProvider extends ChangeNotifier {
 
  String? _userName;
  String? get userName => _userName;

  void setUserName(String? newName) {
    _userName = newName;
  
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName =
      ''; // private variable to hold name(not accessible directly outside)non-nullable, default empty string

  // Getter (this is what you use in Home: userProvider.userName)  // public getter
  String get userName {
    return _userName;
  }

  // Setter (this updates name everywhere)
  void setUserName(String name) {
    _userName = name; // trim removes spaces from start & end
    notifyListeners(); // 🔥 notifies UI to rebuild
  }
}

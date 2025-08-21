import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tickdone/Services/Api/api_service.dart';

class UserProvider extends ChangeNotifier {
  String _userName = ""; //The stored username
  String get userName {
    return _userName;
  }

  //Load username from local storage(called on app start)
  Future<void> loadUserNamefromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? "";
    notifyListeners();
  }

  // Save new username in Provider and locally
  Future<void> setUserName(String newName) async {
    _userName = newName;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName); //save on device
  }

  //Fetch username from firebase
  Future<void> fetchUserNameFromApi(String uid, String idToken) async {
    final url = Uri.parse(
      '${Apiservice.firestoreBaseUrl}/users/$uid?key=${Apiservice.apiKey}',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      final data = json.decode(response.body);
      final fetchedname = data['fields']?['name']?['stringValue'] ?? "";

      if (fetchedname.isNotEmpty && fetchedname != _userName) {
        _userName = fetchedname;
        notifyListeners();
        //save to local
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', fetchedname);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:http/http.dart' as http;

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasksFromFirebase(DateTime selectedDate) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userUid = prefs.getString('userUID');
    _tasks.clear();

    if (userUid == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final url = Uri.parse(
        '${Apiservice.firestoreBaseUrl}:runQuery?key=${Apiservice.apiKey}',
      );
      final queryBody = {
        "structuredQuery": {
          "from": [
            {"collectionId": "tasks"},
          ],
          "where": {
            "compositeFilter": {
              "op": "AND",
              "filters": [
                {
                  "fieldFilter": {
                    "field": {"fieldPath": "date"},
                    "op": "EQUAL",
                    "value": {"stringValue": formattedDate},
                  },
                },
                {
                  "fieldFilter": {
                    "field": {"fieldPath": "userId"},
                    "op": "EQUAL",
                    "value": {"stringValue": userUid},
                  },
                },
              ],
            },
          },
        },
      };
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(queryBody),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        for (var item in data) {
          if (item.containsKey('document')) {
            final doc = item['document'];
            final taskId = doc['name'].split('/').last;
            _tasks.add({'id': taskId, 'fields': doc['fields']});
          }
        }
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final url = Uri.parse(
        '${Apiservice.firestoreBaseUrl}/tasks/$taskId?key=${Apiservice.apiKey}',
      );
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task['id'] == taskId);
        notifyListeners(); // Tell widgets that the list has changed
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }
}

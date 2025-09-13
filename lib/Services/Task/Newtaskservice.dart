// In Newtaskservice.dart
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Addnewtaskservice {
  Future<void> addtasktofirebase(
    Map<String, dynamic> taskdata,
    BuildContext context,
    String userId,
  ) async {
    try {
      if (taskdata.containsKey("date")) {
        final dateValue = taskdata["date"];
        if (dateValue is String && dateValue.isNotEmpty) {
          final formattedDate = DateTime.parse(dateValue);
          taskdata["date"] = {
            "stringValue": DateFormat('yyyy-MM-dd').format(formattedDate),
          };
        }
      }
      taskdata['userId'] = {'stringValue': userId};
      final url = Uri.parse(Apiservice.task);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fields': taskdata}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: 'Task Added Successfully',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Oh Snap!',
              message: 'Failed to add task. Please try again.',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          content: AwesomeSnackbarContent(
            title: 'Oh Snap!',
            message: 'Please check your Internet Connection',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }
}

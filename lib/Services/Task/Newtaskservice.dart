// In Newtaskservice.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tickdone/Model/task.dart';

class Addnewtaskservice {
  Future<void> addtasktofirebase(Task task, BuildContext context) async {
    try {
      final url = Uri.parse(Apiservice.task);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fields': task.toFirebaseJson()}),
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

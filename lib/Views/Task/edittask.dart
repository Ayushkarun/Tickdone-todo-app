// In Edittask.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Services/Provider/task_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:tickdone/Services/Provider/task_provider.dart';
// import 'package:tickdone/Services/Provider/date_provider.dart';

class EditTask extends StatefulWidget {
  final Map taskToEdit;
  const EditTask({super.key, required this.taskToEdit});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final taskkey = GlobalKey<FormState>();

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  DateTime? selectedDate;
  Time? selectedTime;
  String? selectedCategory;

  final List<String> category = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Skill',
    'Home',
  ];

  @override
  void initState() {
    super.initState();
    final fields = widget.taskToEdit['fields'];
    final dateData = fields['date'];
    final timeData = fields['time'];

    // Load existing data into controllers and variables
    titlecontroller.text = fields['title']?['stringValue'] ?? '';
    descriptioncontroller.text = fields['description']?['stringValue'] ?? '';
    selectedCategory = fields['category']?['stringValue'];

    if (dateData != null) {
      String rawDate;
      if (dateData.containsKey('stringValue')) {
        rawDate = dateData['stringValue'];
      } else if (dateData.containsKey('timestampValue')) {
        rawDate = dateData['timestampValue'];
      } else {
        rawDate = '';
      }

      if (rawDate.isNotEmpty) {
        try {
          selectedDate = DateTime.parse(rawDate);
        } catch (e) {
          selectedDate = null;
        }
      }
    }

    if (timeData != null &&
        timeData.containsKey('stringValue') &&
        timeData['stringValue'].isNotEmpty) {
      try {
        final timeString = timeData['stringValue'];
        final format = DateFormat('h:mm a');
        final dateTime = format.parse(timeString);
        selectedTime = Time(hour: dateTime.hour, minute: dateTime.minute);
      } catch (e) {
        selectedTime = null;
      }
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  String formatTime(Time time) {
    final now = DateTime.now();
    final formattedTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat.jm().format(formattedTime);
  }

  bool get isToday {
    if (selectedDate == null) {
      return false;
    }
    final now = DateTime.now();
    return selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  Future<void> updateTaskInFirebase() async {
    try {
      final taskId = widget.taskToEdit['id'];
      final originalFields = widget.taskToEdit['fields'];
      final userId = originalFields['userId']?['stringValue'] ?? '';

      final url = Uri.parse(
        '${Apiservice.firestoreBaseUrl}/tasks/$taskId?key=${Apiservice.apiKey}',
      );

      final updatedTaskData = {
        'title': {'stringValue': titlecontroller.text},
        'description': {'stringValue': descriptioncontroller.text},
        'category': {'stringValue': selectedCategory ?? ''},
        'time': {
          'stringValue': selectedTime != null ? formatTime(selectedTime!) : '',
        },
        'userId': {'stringValue': userId},
      };

      if (selectedDate != null) {
        updatedTaskData['date'] = {
          'stringValue': DateFormat('yyyy-MM-dd').format(selectedDate!),
        };
      } else {
        updatedTaskData['date'] = {'stringValue': ''};
      }

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fields': updatedTaskData}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              behavior: SnackBarBehavior.floating,
              content: AwesomeSnackbarContent(
                title: 'Success',
                message: 'Task Updated Successfully!',
                contentType: ContentType.success,
              ),
            ),
          );

          final taskProvider = Provider.of<TaskProvider>(
            context,
            listen: false,
          );
          final dateProvider = Provider.of<DateProvider>(
            context,
            listen: false,
          );

          await taskProvider.fetchTasksFromFirebase(dateProvider.selectedDate);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              behavior: SnackBarBehavior.floating,
              content: AwesomeSnackbarContent(
                title: 'Oh Snap!',
                message: 'Failed to update task. Please try again.',
                contentType: ContentType.failure,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
        ),
        backgroundColor: const Color(0xFF1C0E6F),
        title: Text(
          'Edit Task',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: taskkey,
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.calendar_month, color: Colors.white),
                        label: Text(
                          selectedDate != null
                              ? 'Change Date: ${formatDate(selectedDate!)}'
                              : 'Select Date',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: presentDatePicker,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Title';
                        }
                        return null;
                      },
                      controller: titlecontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Title",
                        icon: Icon(Icons.title_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: descriptioncontroller,
                      style: TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        icon: Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Select Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children:
                          category.map((String current) {
                            final bool isSelected = selectedCategory == current;
                            return ChoiceChip(
                              label: Text(current),
                              selected: isSelected,
                              selectedColor: const Color(0xFF1C0E6F),
                              backgroundColor: Colors.black87,
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    selectedCategory = current;
                                  } else {
                                    selectedCategory = null;
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 10.h),
                    if (isToday)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C0E6F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 20.w,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value:
                                  selectedTime ??
                                  Time(
                                    hour: DateTime.now().hour,
                                    minute: DateTime.now().minute,
                                  ),
                              onChange: (newTime) {
                                setState(() {
                                  selectedTime = newTime;
                                });
                              },
                              iosStylePicker: true,
                              is24HrFormat: false,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        label: Text(
                          selectedTime != null
                              ? 'Change Time: ${formatTime(selectedTime!)}'
                              : "Pick Time (Optional)",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    Center(
                      child: SizedBox(
                        height: 50.h,
                        width: 0.80.sw,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C0E6F),
                          ),
                          onPressed: () {
                            if (taskkey.currentState?.validate() ?? false) {
                              updateTaskInFirebase();
                            }
                          },
                          child: Text(
                            'Update Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

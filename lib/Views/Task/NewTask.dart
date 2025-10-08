// In NewTask.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Services/Provider/task_provider.dart';
import 'package:tickdone/Services/Task/Newtaskservice.dart';
import 'package:intl/intl.dart';
import 'package:tickdone/Services/Notification/notification_service.dart';
import 'package:tickdone/Model/task.dart';

class Newtask extends StatefulWidget {
  const Newtask({super.key});

  @override
  State<Newtask> createState() => _NewtaskState();
}

class _NewtaskState extends State<Newtask> {
  final taskkey = GlobalKey<FormState>();

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  DateTime? selectedDate;
  Time? selectedTime;

  List<bool> isSelected = [true];
  final List<String> category = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Skill',
    'Home',
  ];
  String? selectedCategory;

  // Simple function to format a DateTime object into "day-month-year".
  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  // Simple function to format a Time object into 12-hour format with AM/PM.
  String formatTime(Time time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  // A helper function to check if the selected date is today.
  bool get isToday {
    if (selectedDate == null) {
      return false;
    }
    final now = DateTime.now();
    return selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;
  }

  void scheduleTaskNotification(String title, DateTime scheduledDateTime) {
    NotificationService().scheduleNotificationAtTime(
      id: title.hashCode, // A simple unique ID for the task
      title: 'Task Reminder:$title ',
      body: 'Lets Do it !!',
      scheduledTime: scheduledDateTime,
    );
  }

  // Shows the single date picker pop-up.
  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  late final double padding = 15.w;
  late final double titleIconSize = 28.sp;
  late final double buttonHeight = 50.h;
  late final double buttonWidth = 0.80.sw;
  late final double textFieldVerticalSpace = 10.h;
  late final double verticalPadding = 12.h;
  late final double horizontalPadding = 20.w;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.white, size: titleIconSize),
        ),
        backgroundColor: const Color(0xFF1C0E6F),
        title: Text(
          'Add Task',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: taskkey,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C0E6F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.r),
                            bottomRight: Radius.circular(25.r),
                          ),
                        ),

                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: presentDatePicker,
                      icon: Icon(Icons.calendar_today, color: Colors.white),
                      label: Text(
                        'Select Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      icon: const Icon(Icons.title_rounded),
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
                      icon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: textFieldVerticalSpace),
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
                    children: List.generate(category.length, (index) {
                      final String current = category[index];
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
                    }),
                  ),
                  SizedBox(height: textFieldVerticalSpace),
                  if (selectedDate != null)
                    Center(
                      child: Text(
                        "Selected Date: ${formatDate(selectedDate!)}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  SizedBox(height: textFieldVerticalSpace),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C0E6F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding,
                      ),
                    ),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
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
                    icon: const Icon(Icons.access_time, color: Colors.white),
                    label: Text(
                      "Pick Time (Optional)",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Show selected time ONLY after the user has picked it.
                  if (selectedTime != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Center(
                        child: Text(
                          "Selected Time: ${formatTime(selectedTime!)}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),

                  Center(
                    child: SizedBox(
                      height: buttonHeight,
                      width: buttonWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C0E6F),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userUid = prefs.getString('userUID');
                          // 1. Check if the form is valid.
                          if (userUid != null) {
                            if (taskkey.currentState?.validate() ?? false) {
                              if (selectedDate == null) {
                                // Show a message to the user.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select a date for your task.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                // Stop the function here so the task isn't saved.
                                return;
                              }
                              final task = Task(
                                title: titlecontroller.text,
                                description: descriptioncontroller.text,
                                category: selectedCategory ?? '',
                                date: DateFormat(
                                  'yyyy-MM-dd',
                                ).format(selectedDate!),
                                time:
                                    selectedTime != null
                                        ? selectedTime!.format(context)
                                        : '',
                                userId: userUid,
                              );

                              // 4. Call the service to save the task.
                              final taskService = Addnewtaskservice();
                              await taskService.addtasktofirebase(
                                task,
                                context,
                              );
                              // Get the TaskProvider instance
                              final taskProvider = Provider.of<TaskProvider>(
                                context,
                                listen: false,
                              );

                              // Get the DateProvider to know which date's tasks to refresh
                              final dateProvider = Provider.of<DateProvider>(
                                context,
                                listen: false,
                              );
                              if (selectedDate != null &&
                                  selectedTime != null) {
                                final now = DateTime.now();
                                final scheduledDateTime = DateTime(
                                  selectedDate!.year,
                                  selectedDate!.month,
                                  selectedDate!.day,
                                  selectedTime!.hour,
                                  selectedTime!.minute,
                                );

                                // Check if the scheduled time is in the past and adjust it if needed.
                                final finalScheduledTime =
                                    scheduledDateTime.isAfter(now)
                                        ? scheduledDateTime
                                        : scheduledDateTime.add(
                                          const Duration(days: 1),
                                        );

                                // Call the new method to schedule the notification.
                                scheduleTaskNotification(
                                  titlecontroller.text,
                                  finalScheduledTime,
                                );
                              }
                              await taskProvider.fetchTasksFromFirebase(
                                dateProvider.selectedDate,
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          'Save Task',
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
      ),
    );
  }
}

// In NewTask.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Services/Task/Newtaskservice.dart';
import 'package:intl/intl.dart';

class Newtask extends StatefulWidget {
  const Newtask({super.key});

  @override
  State<Newtask> createState() => _NewtaskState();
}

class _NewtaskState extends State<Newtask> {
  final taskkey = GlobalKey<FormState>();

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  // A variable to hold the selected date for a single-day task.
  DateTime? selectedDate;
  // A variable to hold the selected time. It starts as null.
  Time? selectedTime;

  // Variables for a multi-day task (date range).
  DateTime? startDate;
  DateTime? endDate;

  // A list of booleans to track which toggle button is selected.
  // [true, false] means "Single Day" is selected by default.
  // We'll keep only 'Single Day' active.
  List<bool> isSelected = [true]; // Changed to a single item list

  // A list of pre-defined categories.
  final List<String> category = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Skill',
    'Home',
  ];
  // A single string to hold the selected category.
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

  // --- Functions to Handle Pickers ---

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
        startDate = null; // Clear date range
        endDate = null; // Clear date range
      });
    });
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ToggleButtons(
                        fillColor: const Color(0xFF1C0E6F),
                        isSelected: isSelected,
                        borderColor: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        onPressed: (int index) {
                          // Since we only have one button, we'll only call the single date picker.
                          if (index == 0) {
                            presentDatePicker();
                          }
                          // else {
                          //   presentDateRangePicker();
                          // }
                        },
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'Single Day',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Form(
                      key: taskkey,
                      child: TextFormField(
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
                    SizedBox(height: 10.h),

                    // Display the selected date or date range.
                    if (selectedDate != null)
                      Text(
                        "Selected Date: ${formatDate(selectedDate!)}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),

                    SizedBox(height: 10.h),

                    // Show the "Pick Time" button ONLY if a single date is selected AND it is today.
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
                        child: Text(
                          "Selected Time: ${formatTime(selectedTime!)}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
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
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final userUid = prefs.getString('userUID');
                            // 1. Check if the form is valid.
                            if (userUid != null) {
                              if (taskkey.currentState?.validate() ?? false) {
                                // 2. If the form is valid, then proceed with creating and saving the task.
                                final taskData = {
                                  'title': {
                                    'stringValue': titlecontroller.text,
                                  },
                                  'description': {
                                    'stringValue': descriptioncontroller.text,
                                  },
                                  'category': {
                                    'stringValue': selectedCategory ?? '',
                                  },
                                  'time': {
                                    'stringValue':
                                        selectedTime != null
                                            ? selectedTime!.format(context)
                                            : '',
                                  },
                                  'userId': {'stringValue': userUid},
                                };

                                // 3. Conditionally add a single date based on user selection.
                                if (selectedDate != null) {
                                  taskData['date'] = {
                                    'stringValue': DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(selectedDate!),
                                  };
                                }

                                // 4. Call the service to save the task.
                                final taskService = Addnewtaskservice();
                                await taskService.addtasktofirebase(
                                  taskData,
                                  context,
                                  userUid!,
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
        ],
      ),
    );
  }
}

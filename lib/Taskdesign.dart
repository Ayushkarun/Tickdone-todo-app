import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:tickdone/Taskdesign.dart'; // Make sure this path is correct

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  // A variable to hold the selected date for a single-day task. It can be null.
  DateTime? _selectedDate;
  // A variable to hold the selected time. It can be null if no time is picked.
  Time? _selectedTime;

  // Variables for a multi-day task (date range). They can be null.
  DateTime? _startDate;
  DateTime? _endDate;

  // A list of booleans to track which toggle button is selected.
  // [true, false] means "Select a Single Day" is selected by default.
  List<bool> _isSelected = [true, false];

  // A list of pre-defined categories. You can add or remove from this list.
  final List<String> _categories = ['Work', 'Personal', 'Shopping', 'Health', 'Home'];
  // NEW: A single string to hold the selected category. It can be null.
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  // This function is for showing the single date picker.
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _startDate = null;
        _endDate = null;
      });
    });
  }

  // This function is for showing the date range picker.
  void _presentDateRangePicker() async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  // This function checks if the selected date is today.
  bool get isToday =>
      _selectedDate != null &&
      _selectedDate!.year == DateTime.now().year &&
      _selectedDate!.month == DateTime.now().month &&
      _selectedDate!.day == DateTime.now().day;

  @override
  void dispose() {
    super.dispose();
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
                    TextFormField(
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
                    SizedBox(height: 20.h),

                    // A title for the category section.
                    Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // NEW: A Wrap widget with ChoiceChips for single category selection.
                    Wrap(
                      spacing: 8.0, // horizontal space between chips
                      children: _categories.map((category) {
                        final bool isSelected = _selectedCategory == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (value) {
                            setState(() {
                              _selectedCategory = value ? category : null;
                            });
                          },
                          selectedColor: Colors.purple,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10.h),

                    // Using a ToggleButtons widget for the selection
                    ToggleButtons(
                      isSelected: _isSelected,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _isSelected.length; i++) {
                            _isSelected[i] = i == index;
                          }
                          if (_isSelected[0]) {
                            _presentDatePicker();
                          } else {
                            _presentDateRangePicker();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      selectedBorderColor: Colors.purple,
                      selectedColor: Colors.white,
                      fillColor: Colors.purple,
                      color: Colors.grey,
                      borderColor: Colors.grey,
                      borderWidth: 1,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('Single Day', style: TextStyle(color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('Date Range', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Display the selected dates based on what the user picked
                    if (_startDate != null && _endDate != null)
                      Text(
                        'Task from: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year} to ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      )
                    else if (_selectedDate != null)
                      Text(
                        'Selected Day: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    SizedBox(height: 10.h),

                    // Show the "Pick Time" button ONLY if a single date is selected AND it is today
                    if (isToday && _startDate == null)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: _selectedTime ?? Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
                              onChange: (newTime) {
                                setState(() {
                                  _selectedTime = newTime;
                                });
                              },
                              iosStylePicker: true,
                              is24HrFormat: false,
                            ),
                          );
                        },
                        child: Text("Pick Time (Optional)"),
                      ),
                    
                    // Display the selected time if it exists
                    if (_selectedTime != null)
                      Text(
                        "Selected Time: ${_selectedTime!.format(context)}",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    SizedBox(height: 10.h),

                    ElevatedButton(
                      onPressed: () {
                        // The logic for what happens when the user presses 'Task' would go here.
                        // You can access the selected category with `_selectedCategory`.
                        // print('Selected category: $_selectedCategory');
                      },
                      child: Text('Task'),
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


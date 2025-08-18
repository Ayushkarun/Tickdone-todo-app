import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class Newtask extends StatefulWidget {
  const Newtask({super.key});

  @override
  State<Newtask> createState() => _NewtaskState();
}

class _NewtaskState extends State<Newtask> {
  Time _time = Time(hour: 10, minute: 30, second: 0);

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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white, 
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Title',
                        icon: Icon(Icons.title_rounded),
                        helperText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Enter Desc'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _time,
                            onChange: (newTime) {
                              setState(() {
                                _time = newTime;
                              });
                            },
                            iosStylePicker: true,
                            is24HrFormat: false,
                          ),
                        );
                      },
                      child: Text(
                        "Today (Pick Time)",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                    Text(
                      "Selected Time: ${_time.format(context)}",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
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

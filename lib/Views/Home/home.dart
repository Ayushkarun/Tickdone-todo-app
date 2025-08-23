import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Provider/user_provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Views/Home/Emptytaskpage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // A dummy list to simulate having tasks.
  final List<String> taskList = ['Go to the gym', 'Buy groceries', 'Read a book', 'Buy groceries', 'Buy groceries', 'Buy groceries', 'Buy groceries'];

  // This function removes a task from the list at a specific position (index).
  void deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This is where we check if the list is empty.
    Widget taskContent;
    if (taskList.isEmpty) {
      taskContent = Emptytask();
    } else {
      taskContent = Column(
        children: [
          // The card with the blurry container is now part of the taskContent
          // so it only displays when the taskList is not empty.
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 140.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -40.h,
                      left: -40.w,
                      child: Container(
                        width: 160.w,
                        height: 160.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF10083F), // Darkest purple
                              Color(0xFF2B1B80), // Mid-blue
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50.h,
                      right: -50.w,
                      child: Container(
                        width: 180.w,
                        height: 180.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2B1B80), // Mid-blue
                              Color(0xFF5C39FF), // Brightest purple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    BlurryContainer(
                      blur: 15,
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 110.h,
                      elevation: 0,
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      padding: const EdgeInsets.all(0),
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h), // Add some space between the card and the list
          Expanded(
            child: ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white10,
                  margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 0.w),
                  child: ListTile(
                    title: Text(
                      taskList[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white70),
                      onPressed: () {
                        deleteTask(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 15.h,
            bottom: 5.h,
            left: 15.w,
            right: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      String displayName = "User";
                      if (userProvider.userName.isNotEmpty) {
                        displayName = userProvider.userName;
                      }
                      return Text(
                        'Hello, $displayName!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 27.sp,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Container(
                child: DatePicker(
                  DateTime.now(),
                  height: 78.h,
                  width: 55.w,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: const Color(0xFF1C0E6F),
                  selectedTextColor: Colors.white,
                  dateTextStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                  ),
                  dayTextStyle: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  monthTextStyle: TextStyle(
                    fontSize: 6.sp,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  onDateChange: (date) {
                    Provider.of<DateProvider>(
                      context,
                      listen: false,
                    ).setSelectedDate(date);
                  },
                ),
              ),
              SizedBox(height: 2.h),
              Center(
                child: Consumer<DateProvider>(
                  builder: (context, dateProvider, child) {
                    return Text(
                      DateFormat('d MMM').format(dateProvider.selectedDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 21.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 3.h),
              Expanded( // This is the new change.
                child: taskContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
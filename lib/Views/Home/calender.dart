// import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Services/Provider/task_provider.dart';
import 'package:tickdone/Views/Home/Emptytaskpage.dart';
import 'package:tickdone/Views/Task/Taskview.dart';
import 'package:tickdone/Views/Widget/snackBar.dart';
// import 'package:tickdone/Services/Api/api_service.dart';
// import 'package:http/http.dart' as http;

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  // List<Map<String, dynamic>> task = [];
  // bool isLoading = true;
  DateTime today = DateTime.now();

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'shopping':
        return Colors.orange;
      case 'health':
        return Colors.red;
      case 'skill':
        return Colors.purple;
      case 'home':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  void onDayselect(DateTime day, DateTime focusedDay) {
    // You no longer need setState here since the provider handles the state change
    Provider.of<DateProvider>(context, listen: false).setSelectedDate(day);
    Provider.of<TaskProvider>(
      context,
      listen: false,
    ).fetchTasksFromFirebase(day);
  }


  @override
  void initState() {
    super.initState();
    // When the calendar page first loads, fetch tasks for today's date.
    // fetchTaskfromfirebase(today);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).fetchTasksFromFirebase(today);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = context.watch<DateProvider>(); // Watch the provider
    final selectedDate = dateProvider.selectedDate; // Get the selected date
    final taskProvider = context.watch<TaskProvider>();
    final isLoading = taskProvider.isLoading;
    final tasks = taskProvider.tasks;
    String dayname = DateFormat("EEE").format(selectedDate);
    String datemonth = DateFormat("d MMMM").format(selectedDate);

    Widget mainContent;

    if (isLoading) {
      mainContent = Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: LinearProgressIndicator(
          backgroundColor: Colors.grey[800],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      );
    } else if (tasks.isEmpty) {
      mainContent = Emptytask();
    } else {
      mainContent = Expanded(
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskItem = tasks[index];
            final taskId = taskItem['id'];
            final title = taskItem['fields']['title']['stringValue'];
            final description =
                taskItem['fields']['description']['stringValue'];
            final category = taskItem['fields']['category']['stringValue'];
            final time = taskItem['fields']['time']['stringValue'];

            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
                side: const BorderSide(color: Color(0xFF1C0E6F), width: 1.5),
              ),
              child: ListTile(
                onTap: () async {                  
                  await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              TaskView(task: taskItem),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                  // After returning from the TaskView, refresh the tasks
                  // fetchTaskfromfirebase(today);
                  taskProvider.fetchTasksFromFirebase(today);
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 5.h,
                ),
                tileColor: Colors.transparent,
                title: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                    fontFamily: 'Poppins',
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        if (category.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: getCategoryColor(category),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (time.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              'Due:$time',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final success = await taskProvider.deleteTask(taskId);
                    if (success) {
                      Mysnackbar.detail(
                        context,
                        title: 'Success!',
                        message: 'Task deleted successfully!',
                        contentType: ContentType.success,
                      );
                    } else {
                      Mysnackbar.detail(
                        context,
                        title: 'Oh Snap!',
                        message: 'Failed to delete task. Please try again.',
                        contentType: ContentType.failure,
                      );
                    }
                  },
                  icon: Icon(Icons.delete, color: Colors.red[400]),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.black,
                child: TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                  rowHeight: 40.h,
                  focusedDay: selectedDate,
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 13.sp,
                    ),
                    outsideTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.sp,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF1C0E6F),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                  firstDay: DateTime.utc(2025, 08, 01),
                  lastDay: DateTime.utc(2030),
                  onDaySelected: onDayselect,
                ),
              ),
            ),
            Center(
              child: Text(
                "$dayname,$datemonth",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            mainContent,
          ],
        ),
      ),
    );
  }
}

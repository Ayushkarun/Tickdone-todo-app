// In home.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:tickdone/Services/Provider/user_provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Views/Home/Aboutus.dart';
import 'package:tickdone/Views/Home/Emptytaskpage.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tickdone/Views/Task/Taskview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> task = []; // To store fetched tasks
  bool isLoading = true;

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
        return Colors.grey; // A default color if the category is not found
    }
  }

  Future fetchTasksFromFirebase() async {
    setState(() {
      isLoading = true;
    });

    try {
      final selectedDate =
          Provider.of<DateProvider>(context, listen: false).selectedDate;

      if (selectedDate != null) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        //1
        final url = Uri.parse(
          '${Apiservice.firestoreBaseUrl}:runQuery?key=${Apiservice.apiKey}',
        );

        final singleDayQueryBody = {
          "structuredQuery": {
            "from": [
              {"collectionId": "tasks"},
            ],
            "where": {
              "fieldFilter": {
                "field": {"fieldPath": "date"},
                "op": "EQUAL",
                "value": {"stringValue": formattedDate},
              },
            },
          },
        };
        //2
        // Post requests for both queries
        final singleDayResponse = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(singleDayQueryBody),
        );

        //3

        task.clear();

        if (singleDayResponse.statusCode == 200) {
          final List singleDayData = json.decode(singleDayResponse.body);
          for (var item in singleDayData) {
            if (item.containsKey('document')) {
              final doc = item['document'];
              final taskId = doc['name'].split('/').last;
              task.add({'id': taskId, 'fields': doc['fields']});
            }
          }
        }

        ///4
      } else {
        task.clear();
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      task.clear();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final url = Uri.parse(
        '${Apiservice.firestoreBaseUrl}/tasks/$taskId?key=${Apiservice.apiKey}',
      );
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: 'Task deleted successfully!',
              contentType: ContentType.success,
            ),
          ),
        );
        await fetchTasksFromFirebase();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Oh Snap!',
              message: 'Failed to delete task. Please try again.',
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
            message: 'An error occurred while deleting the task: $e',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasksFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (isLoading) {
      mainContent = Center(child: CircularProgressIndicator());
    } else if (task.isEmpty) {
      mainContent = Emptytask();
    } else {
      mainContent = Column(
        children: [
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
                            colors: [Color(0xFF10083F), Color(0xFF2B1B80)],
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
                            colors: [Color(0xFF2B1B80), Color(0xFF5C39FF)],
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
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.builder(
              itemCount: task.length,

              itemBuilder: (context, index) {
                final taskItem = task[index];

                final taskId = taskItem['id'];

                final title = taskItem['fields']['title']['stringValue'];
                final description =
                    taskItem['fields']['description']['stringValue'];
                final category = taskItem['fields']['category']['stringValue'];
                final time = taskItem['fields']['time']['stringValue'];

                String? displayDate;

                if (taskItem['fields']['date'] != null) {
                  final date =
                      taskItem['fields']['date'].containsKey('timestampValue')
                          ? taskItem['fields']['date']['timestampValue']
                          : taskItem['fields']['date']['stringValue'];

                  if (date != null && date.isNotEmpty) {
                    try {
                      final parsedDate = DateTime.parse(date);
                      displayDate = DateFormat(
                        'dd MMM yyyy',
                      ).format(parsedDate.toLocal());
                    } catch (e) {
                      displayDate = 'Invalid Date';
                    }
                  }
                }
                //5
                return Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    side: const BorderSide(
                      color: Color(0xFF1C0E6F),
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => TaskView(task: taskItem),));
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
                                  'Due: $time',
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
                      icon: Icon(Icons.delete, color: Colors.red[400]),
                      onPressed: () {
                        deleteTask(taskId);
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
                    fetchTasksFromFirebase();
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
              Expanded(child: mainContent),
            ],
          ),
        ),
      ),
    );
  }
}

/*
         // print(
                //   "Rendering task: ID=${taskItem['id']}, date present=${taskItem['fields']['date'] != null}, "
                //   "startDate present=${taskItem['fields']['startDate'] != null}",
                // );

                1
                        // final utcSelectedDate = DateTime.utc(
        //   selectedDate.year,
        //   selectedDate.month,
        //   selectedDate.day,
        // );

        2
                // final dateRangeQueryBody = {
        //   "structuredQuery": {
        //     "from": [
        //       {"collectionId": "tasks"}
        //     ],
        //     "where": {
        //       "compositeFilter": {
        //         "op": "AND",
        //         "filters": [
        //           {
        //             "fieldFilter": {
        //               "field": {"fieldPath": "startDate"},
        //               "op": "LESS_THAN_OR_EQUAL",
        //               "value": {
        //                 "timestampValue": utcSelectedDate.toIso8601String()
        //               }
        //             }
        //           },
        //           {
        //             "fieldFilter": {
        //               "field": {"fieldPath": "endDate"},
        //               "op": "GREATER_THAN_OR_EQUAL",
        //               "value": {
        //                 "timestampValue": utcSelectedDate.toIso8601String()
        //               }
        //             }
        //           }
        //         ]
        //       }
        //     }
        //   }
        // };

        3
                // final dateRangeResponse = await http.post(
        //   url,
        //   headers: {"Content-Type": "application/json"},
        //   body: json.encode(dateRangeQueryBody),
        // );

        4

                // if (dateRangeResponse.statusCode == 200) {
        //   print("Date-range response body: ${dateRangeResponse.body}");
        //   final List dateRangeData = json.decode(dateRangeResponse.body);
        //   for (var item in dateRangeData) {
        //     if (item.containsKey('document')) {
        //       final doc = item['document'];
        //       final taskId = doc['name'].split('/').last;
        //       if (!task.any((t) => t['id'] == taskId)) {
        //         print("Adding date-range task: $taskId"); // Add debug here
        //         task.add({'id': taskId, 'fields': doc['fields']});
        //       }
        //     }
        //   }
        // } else {
        //   print(
        //     "Date-range query failed with status ${dateRangeResponse.statusCode}",
        //   );
        // }

        //5
                        // else if (taskItem['fields']['startDate'] != null &&
                //     taskItem['fields']['endDate'] != null) {
                //   final startDate =
                //       taskItem['fields']['startDate']['timestampValue'];
                //   final endDate =
                //       taskItem['fields']['endDate']['timestampValue'];

                //   if (startDate != null && endDate != null) {
                //     try {
                //       final parsedStartDate =
                //           DateTime.parse(startDate).toLocal();
                //       final parsedEndDate = DateTime.parse(endDate).toLocal();
                //       displayDate =
                //           'Range: ${DateFormat('dd MMM yyyy').format(parsedStartDate)} to ${DateFormat('dd MMM yyyy').format(parsedEndDate)}';
                //     } catch (e) {
                //       displayDate = 'Invalid Date Range';
                //     }
                //   }
                // }





*/

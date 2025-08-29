import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tickdone/calendertask/taskadd.dart';
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:http/http.dart' as http;

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  List<Map<String, dynamic>> task = [];
  bool isLoading = true;
  DateTime today = DateTime.now();

  Future<void> fetchTaskfromfirebase(DateTime selectedDate) async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = prefs.getString('userUID');
    setState(() {
      isLoading = true;
    });
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final url = Uri.parse(
        '${Apiservice.firestoreBaseUrl}:runQuery?key=${Apiservice.apiKey}',
      );
      final singleDayQueryBody = {
        "structuredQuery": {
          "from": [
            {"collectionId": "tasks"},
          ],
          "where": {
            "compositeFilter": {
              "op": "AND",
              "filters": [
                {
                  "fieldFilter": {
                    "field": {"fieldPath": "date"},
                    "op": "EQUAL",
                    "value": {"stringValue": formattedDate},
                  },
                },
                {
                  "fieldFilter": {
                    "field": {"fieldPath": "userId"},
                    "op": "EQUAL",
                    "value": {"stringValue": userUid},
                  },
                },
              ],
            },
          },
        },
      };
      final singleDayResponse = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(singleDayQueryBody),
      );
      task.clear();

      if(singleDayResponse.statusCode==200){
        final List singleDayData=json.decode(singleDayResponse.body);
        for(var item in singleDayData){
          if(item.containsKey('document')){
            final doc=item['document'];
          }
        }
      }
    }
    
     catch (e) {

    }
  }

  void onDayselect(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    String dayname = DateFormat("EEE").format(today);
    String datemonth = DateFormat("d MMMM").format(today);

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
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
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  rowHeight: 42.h,
                  focusedDay: today,
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                    outsideTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
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
                  fontSize: 15.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Taskadder()),
                );
              },
              child: Text('Task'),
            ),
          ],
        ),
      ),
    );
  }
}

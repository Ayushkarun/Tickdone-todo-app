import 'package:flutter/material.dart';
import 'package:tickdone/Views/Home/Account.dart';
import 'package:tickdone/Views/Home/calender.dart';
import 'package:tickdone/Views/Home/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Views/Task/NewTask.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Services/Provider/task_provider.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int selectedindex = 0;

  final List<Widget> widgetoptions = [Home(), Calender(), Account()];

  @override
  Widget build(BuildContext context) {
    Widget? floatbutton;
    void onTabTapped(int index) {
      if (selectedindex == 1 && index == 0) {
        final dateProvider = context.read<DateProvider>();
        final taskProvider = context.read<TaskProvider>();
        final today = DateTime.now();

        // Set selected date to today
        dateProvider.setSelectedDate(today);

        // Fetch today's tasks for Home screen
        taskProvider.fetchTasksFromFirebase(today);
      }
      setState(() {
        selectedindex = index;
      });
    }
    if (selectedindex == 0 || selectedindex == 1) {
      floatbutton = FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => Newtask(),
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
        },
        backgroundColor: const Color(0xFF1C0E6F),
        child: Icon(Icons.add, color: Colors.white),
      );
    } else {
      floatbutton = null;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        onTap:onTabTapped,
        backgroundColor: Colors.black,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B1B80),
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 23.sp,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
      body: IndexedStack(index: selectedindex, children: widgetoptions),
      floatingActionButton: floatbutton,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tickdone/Views/Home/Account.dart';
import 'package:tickdone/Views/Home/calender.dart';
import 'package:tickdone/Views/Home/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Views/Task/NewTask.dart';

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
    if (selectedindex == 0) {
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
        onTap: (int index) {
          setState(() {
            selectedindex = index;
          });
        },
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

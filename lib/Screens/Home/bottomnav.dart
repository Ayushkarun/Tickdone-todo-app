import 'package:flutter/material.dart';
import 'package:tickdone/Screens/Home/Account.dart';
import 'package:tickdone/Screens/Home/calender.dart';
import 'package:tickdone/Screens/Home/home.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
    int selectedindex = 0;

    List<Widget> widgetoptions=[
      Home(),
      Calender(),
      Account()
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Calender",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),
        body: widgetoptions.elementAt(selectedindex),
    
    );
  }
}
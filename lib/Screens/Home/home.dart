import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false, 
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
      ),
      body: Center(child: Text('Home')),
    ),
  );
}
}
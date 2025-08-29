import 'package:flutter/material.dart';

class Taskadder extends StatefulWidget {
  const Taskadder({super.key});

  @override
  State<Taskadder> createState() => _TaskadderState();
}

class _TaskadderState extends State<Taskadder> {
  Future<void> datepicker() async{
    DateTime initial=DateTime.now();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Add task')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('select date'),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

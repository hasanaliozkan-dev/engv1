import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';
import 'student/faculty.dart';
import 'student/notifications.dart';
import 'student/profile.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
     const List<Widget> widgetOptions = <Widget>[
      FacultyPage(),
      NotificaitonsPage(),
      ProfilePage(),
    ];
    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(

    body: Center(

     child: widgetOptions.elementAt(selectedIndex),
     ),
    bottomNavigationBar: BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
    icon: Icon(Icons.school),
    label: 'Faculty',

    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.notifications_active),
    label: 'Notifications',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
    ),
    ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    ),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:engv1/teacher/new_notification.dart';
import 'package:engv1/teacher/old_notifications.dart';


class Teacher extends StatefulWidget {
  final String dep;
  const Teacher({super.key, required this.dep});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
     List<Widget> widgetOptions = <Widget>[
      NewNotification(dep: widget.dep),
      const OldNotifications(),
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
            icon: Icon(Icons.edit_notifications),
            label: 'New Notification',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_paused),
            label: 'Old Notifications',
            backgroundColor: Colors.green,
          ),

        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }


}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:engv1/admin/new_notification.dart';
import 'package:engv1/admin/old_notifications.dart';

import 'sign_in.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _Admin();
}

class _Admin extends State<Admin> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    const List<Widget> widgetOptions = <Widget>[
      NewNotification(),
      OldNotifications(),
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

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_paused),
            label: 'Old Notifications',

          ),

        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }
}

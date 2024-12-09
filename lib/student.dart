import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    checkUnreadNotifications();
  }

  void checkUnreadNotifications() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        List<dynamic> messages = snapshot.get('received_messages') ?? [];
        bool hasUnread = messages.any((message) => message['isRead'] == false);
        setState(() {
          hasUnreadNotifications = hasUnread;
        });
      }
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 1) {
        // Bildirimler sekmesine tıklanırsa, unread durumunu sıfırla
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'received_messages': FieldValue.arrayUnion([]),
        });
        hasUnreadNotifications = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<Widget> widgetOptions = <Widget>[
      FacultyPage(),
      NotificaitonsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Faculty',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 11,
                        minHeight: 11,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
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

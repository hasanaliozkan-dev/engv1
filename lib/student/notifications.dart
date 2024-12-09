import 'package:flutter/material.dart';
import 'package:engv1/student_notifications/starred.dart';
import 'package:engv1/student_notifications/old.dart';
import 'package:engv1/student_notifications/new.dart';

class NotificaitonsPage extends StatefulWidget  {
  const NotificaitonsPage({super.key});

  @override
  _NotificaitonsPageState createState() => _NotificaitonsPageState();
}

class _NotificaitonsPageState extends State<NotificaitonsPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "New"),
            Tab(text: "Starred"),
            Tab(text: "Old"),
          ],
        )
      ),

    body: TabBarView(
        controller: tabController,
        children: const [
          Center(
              child: NewNotificationPage()),
          Center(
              child: StarredNotificationsPage()),
          Center(
              child: DeletedNotificationsPage()),

        ],
      ),

    );
  }
}
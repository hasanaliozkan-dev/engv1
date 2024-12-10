import 'package:flutter/material.dart';

class NotificaitonsPage extends StatefulWidget  {
  const NotificaitonsPage({Key? key}) : super(key: key);

  @override
  _NotificaitonsPageState createState() => _NotificaitonsPageState();
}

class _NotificaitonsPageState extends State<NotificaitonsPage> with TickerProviderStateMixin {

  List<String> notifications = ['Notification 1', 'Notification 2', 'Notification 3'];
  List<bool> isStarred = [false, false, false];


  void toggleStar(int index) {
    setState(() {
      isStarred[index] = !isStarred[index];
    });
  }


  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      isStarred.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "New"),
            Tab(text: "Starred"),
            Tab(text: "Old"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [

          ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationItem(
                notificationText: notifications[index],
                isStarred: isStarred[index],
                onDelete: () => deleteNotification(index),
                onToggleStar: () => toggleStar(index),
              );
            },
          ),

          ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              if (isStarred[index]) {
                return NotificationItem(
                  notificationText: notifications[index],
                  isStarred: isStarred[index],
                  onDelete: () => deleteNotification(index),
                  onToggleStar: () => toggleStar(index),
                );
              }
              return Container();
            },
          ),

          ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationItem(
                notificationText: notifications[index],
                isStarred: isStarred[index],
                onDelete: () => deleteNotification(index),
                onToggleStar: () => toggleStar(index),
              );
            },
          ),
        ],
      ),
    );
  }
}


class NotificationItem extends StatelessWidget {
  final String notificationText;
  final bool isStarred;
  final VoidCallback onDelete;
  final VoidCallback onToggleStar;

  NotificationItem({
    required this.notificationText,
    required this.isStarred,
    required this.onDelete,
    required this.onToggleStar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notificationText),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isStarred ? Icons.star : Icons.star_border,
              color: isStarred ? Colors.yellow : Colors.grey,
            ),
            onPressed: onToggleStar,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
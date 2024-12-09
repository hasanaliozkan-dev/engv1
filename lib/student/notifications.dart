import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:engv1/student_notifications/starred.dart';
import 'package:engv1/student_notifications/old.dart';
import 'package:engv1/student_notifications/new.dart';

class NotificaitonsPage extends StatefulWidget {
  const NotificaitonsPage({Key? key}) : super(key: key);

  @override
  _NotificaitonsPageState createState() => _NotificaitonsPageState();
}

class _NotificaitonsPageState extends State<NotificaitonsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _notificationTitle;
  String? _notificationBody;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Bildirim izinlerini iste
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı bildirimleri kabul etti.');

      // Firebase Messaging tokenini al
      String? token = await messaging.getToken();
      print('Firebase Messaging Token: $token');

      // Gelen mesajları dinle
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        setState(() {
          _notificationTitle = message.notification?.title ?? "Başlık Yok";
          _notificationBody = message.notification?.body ?? "Mesaj Yok";
        });
        _showSnackbar(_notificationTitle, _notificationBody);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Uygulama bildirimle açıldı: ${message.notification}');
      });
    } else {
      print('Kullanıcı bildirimleri reddetti.');
    }
  }

  void _showSnackbar(String? title, String? body) {
    if (title != null && body != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(body),
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "New"),
            Tab(text: "Starred"),
            Tab(text: "Old"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: NewNotificationPage()),
          Center(child: StarredNotificationsPage()),
          Center(child: DeletedNotificationsPage()),
        ],
      ),
    );
  }
}

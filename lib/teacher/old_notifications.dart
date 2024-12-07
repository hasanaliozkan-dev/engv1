import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:engv1/teacher/notification_list.dart';
import 'package:engv1/utils/api.dart';

class OldNotifications extends StatefulWidget {
  const OldNotifications({super.key});
  @override
  _OldNotifications createState() => _OldNotifications();
}

class _OldNotifications extends State<OldNotifications> {
  final Api _api = Api();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.black,),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              _api.logout(context);
                        },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            SizedBox(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,

                        child: const Center(
                          child:NotificationList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
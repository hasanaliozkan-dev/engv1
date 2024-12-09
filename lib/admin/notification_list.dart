import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engv1/utils/api.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  final notificationStream =
      FirebaseFirestore.instance.collection("admin").snapshots();
  bool starred = false;
  final Api _api = Api();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: StreamBuilder(
          stream: notificationStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Connection Error"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );

            }
            var docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text("There is not any notification"));
            }
            // return Text('${docs.length}');
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: docs.length,


                itemBuilder: (context, index) {

                  return ListTile(
                      title: Text(docs[index]['header']),
                      subtitle: Text(_api.convertDateTimeDisplay(
                          '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children:
                      [
                        IconButton(onPressed: () async {
                          DocumentSnapshot? ds = snapshot.data!.docs[index];

                          _api.delete(ds,'admin');
                        },
                            icon: const Icon(Icons.delete_forever)),
                      ]),
                      onTap: () {
                        //Open a pop up to show the message
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _api.notification(context, index, docs);
                            });
                      });
                });
          },
        ));
  }
}

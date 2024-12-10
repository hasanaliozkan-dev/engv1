import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engv1/utils/api.dart';

class NotificationList extends StatefulWidget {
  final int source;
  final String filter1;
  final bool value1;
  final String filter2;
  final bool value2;

  const NotificationList(
      {Key? key,
      required this.source,
      required this.filter1,
      required this.value1,
      required this.filter2,
      required this.value2})
      : super(key: key);

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  //get current user fields on the users document

  final userStream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Api _api = Api();

  bool starred = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Connection Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var docs = snapshot.data!.get('received_messages');
        //Sort descending order
        if (docs.length == 0) {
          return const Center(child: Text("There is not any notification"));
        }
        //return Text('${docs.length}');
        return ListView.builder(
          //sort by date

          physics: const NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return (docs[index][widget.filter1] == widget.value1 &&
                      docs[index][widget.filter2] == widget.value2)
                  ? ListTile(
                      title: Text(docs[index]['header']),
                      subtitle: Text(_api.convertDateTimeDisplay(
                          '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () {
                              setState(() async {
                                var dc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .get();
                                //Update starred
                                var message = dc['received_messages'] as List;
                                message[index]['isStarred'] =
                                    !message[index]['isStarred'];
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({'received_messages': message});

                                //update isStarred field
                                docs[index]['isStarred'] =
                                    !docs[index]['isStarred'];
                              });
                            },
                            icon: Icon(docs[index]['isStarred']
                                ? Icons.star
                                : Icons.star_border)),
                        (widget.source != 0)
                            ? IconButton(
                                onPressed: () async {
                                  var message = docs as List;
                                  message.removeAt(index);
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({'received_messages': message});
                                },
                                icon: const Icon(Icons.delete_forever))
                            : Container(),
                      ]),
                      onTap: () {
                        //Open a pop up to show the message
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _api.notification(context, index, docs);
                            });
                        setState(() async {
                          var dc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .get();
                          var message = dc['received_messages'] as List;
                          message[index]['isRead'] = true;
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({'received_messages': message});
                        });
                      })
                  : Container();
            });
      },
    ));
  }
}

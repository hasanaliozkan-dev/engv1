import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../sign_in.dart';

class Api {
  final _departments = [
    "Computer Engineering",
    "Software Engineering",
    "Civil Engineering",
    "Electrical and Electronic Engineering",
    "Metallurgy and Material Engineering",
    "Geological Engineering",
    "Mining Engineering"
  ];

  getDepartmentName(int index) {
    return _departments[index];
  }

  downloadFile(String url, String filename) async {
    //save to downloads folder
    var dir = await getExternalStorageDirectory();
    var file = File("${dir!.path}/$filename");
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    await file.writeAsBytes(bytes);
    print(file.path);
    Fluttertoast.showToast(msg: "The file is downloaded to your device");
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  delete(DocumentSnapshot ds, String document) async {
    FirebaseFirestore.instance.collection(document).doc(ds.id).delete();

    int intDepartment = ds['department'];

    int intGrade = ds['grade'];
    var docId = ds.id;
    QuerySnapshot<Map<String, dynamic>> userIds;

    if (intGrade == 5 && intDepartment == 7) {
      userIds = await FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: "student")
          .get();
    } else if (intGrade == 5) {
      userIds = await FirebaseFirestore.instance
          .collection("users")
          .where("department", isEqualTo: intDepartment)
          .get();
    } else if (intDepartment == 7) {
      userIds = await FirebaseFirestore.instance
          .collection("users")
          .where("grade", isEqualTo: intGrade)
          .get();
    } else {
      userIds = await FirebaseFirestore.instance
          .collection("users")
          .where("grade", isEqualTo: intGrade)
          .where("department", isEqualTo: intDepartment)
          .get();
    }

    for (var userId in userIds.docs) {
      var dc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.id)
          .get();
      var message = dc['received_messages'] as List;

      message.removeWhere((element) => element['docId'] == docId.toString());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.id)
          .update({'received_messages': message});
    }
  }

  void send_notification(
      String document,
      int depint,
      String? fileName,
      File? fileToDisplay,
      String header,
      String body,
      String grade,
      String department,
      Timestamp date) async {
    const CircularProgressIndicator();
    // Get user id by their department and grade
    try {
      var intGrade = int.parse(grade);
      var intDepartment =
          document == 'teacher' ? depint : int.parse(department);

      var documentId = Random().nextInt(1000000000);
      QuerySnapshot<Map<String, dynamic>> userIds;

      if (intGrade == 5 && intDepartment == 7) {
        userIds = await FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "student")
            .get();
      } else if (intGrade == 5) {
        userIds = await FirebaseFirestore.instance
            .collection("users")
            .where("department", isEqualTo: intDepartment)
            .get();
      } else if (intDepartment == 7) {
        userIds = await FirebaseFirestore.instance
            .collection("users")
            .where("grade", isEqualTo: intGrade)
            .get();
      } else {
        userIds = await FirebaseFirestore.instance
            .collection("users")
            .where("grade", isEqualTo: intGrade)
            .where("department", isEqualTo: intDepartment)
            .get();
      }
      print("user ids: ${userIds.docs}");

      if (fileName != null) {
        print("file name: ${fileName!}");
        String filName2Upload =
            "${fileName.split(".")[0]}-$documentId.${fileName.split(".")[1]}";

        Reference imageRef =
            FirebaseStorage.instance.ref().child(filName2Upload);
        await imageRef.putFile(fileToDisplay!);

        String imageUrl = await imageRef.getDownloadURL();

        fileToDisplay = null;

        await FirebaseFirestore.instance
            .collection(document)
            .doc(documentId.toString())
            .set({
          'header': header,
          'body': body,
          'grade': intGrade,
          'department': intDepartment,
          'date': date,
          'image_url': imageUrl,
          'file_name': fileName,
        });

        // Write message to the user id found
        for (var userId in userIds.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId.id)
              .update({
            'received_messages': FieldValue.arrayUnion([
              {
                'header': header,
                'body': body,
                'grade': intGrade,
                'department': intDepartment,
                'date': date,
                'docId': documentId.toString(),
                'isStarred': false,
                'image_url': imageUrl,
                'file_name': fileName,
                'isRead': false,
              }
            ])
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection(document)
            .doc(documentId.toString())
            .set({
          'header': header,
          'body': body,
          'grade': intGrade,
          'department': intDepartment,
          'date': date,
          'image_url': null,
          'file_name': null,
        });

        // Write message to the user id found
        for (var userId in userIds.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId.id)
              .update({
            'received_messages': FieldValue.arrayUnion([
              {
                'header': header,
                'body': body,
                'grade': intGrade,
                'department': intDepartment,
                'date': date,
                'docId': documentId.toString(),
                'isStarred': false,
                'image_url': null,
                'file_name': null,
                'isRead': false
              }
            ])
          });
        }
      }
      Fluttertoast.showToast(msg: "The notification was sent successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "The notification was not sent");
      print("The error is ----> $e");
    }
  }

//create a function that returns dialog widget
  Widget notification(BuildContext context, int index, List docs) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AlertDialog(
          scrollable: true,
          title: Text(docs[index]['header'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Text(docs[index]['body'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
                //horizontal rule
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 0.4,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Post Date: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(convertDateTimeDisplay(
                        '${DateUtils.dateOnly(docs[index]["date"].toDate())}')),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                ),
                docs[index]['image_url'] != null
                    ? TextButton(
                        onPressed: () {
                          String link = docs[index]['image_url'];
                          String filename = docs[index]['file_name'];
                          downloadFile(link, filename);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Download material")],
                        ))
                    : const SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"))
          ],
        ));
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

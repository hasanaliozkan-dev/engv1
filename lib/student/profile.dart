import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:engv1/utils/api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final _user_stream =
      FirebaseFirestore.instance.collection("users").snapshots();

  final Api _api = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Create user profile page
      body: StreamBuilder(
        stream: _user_stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Connection Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var currentUserId = FirebaseAuth.instance.currentUser!.uid;
          print(currentUserId);
          //getUsername by currentUserID
          var currentUserDoc = snapshot.data!.docs
              .where((element) => element.id == currentUserId);
          //return Text('${currentUserDoc}');
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),

                const Text("Profile",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 0.7,
                  indent: MediaQuery.sizeOf(context).width * 0.1,
                  endIndent: MediaQuery.sizeOf(context).width * 0.1,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                //Reach data by username

                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Username:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentUserDoc.first['email'].toString().split('@')[0],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(currentUserDoc.first['email']),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Department:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        "${_api.getDepartmentName(currentUserDoc.first['department'])}",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                Container(
                  padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.04),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Grade:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          currentUserDoc.first['grade'] == 0 ? "Freshman" : currentUserDoc.first['grade'] == 1 ? "Sophomore" : currentUserDoc.first['grade'] == 2 ? "Junior" : "Senior",
                          ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                ),
                //Update button that opens an pop up

                //Logout button
                Container(
                  margin: const EdgeInsets.only(right: 20,left: 20),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(

                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        //go to sign in page
                        _api.logout(context);
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Icon(
                              Icons.logout,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.03,
                          ),
                          const Text("Logout"),

                        ],
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }

}

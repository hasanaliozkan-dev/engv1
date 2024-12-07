import 'dart:io';
import 'package:engv1/utils/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewNotification extends StatefulWidget {
  const NewNotification({super.key});
  @override
  _NewNotificationState createState() => _NewNotificationState();
}



class _NewNotificationState extends State<NewNotification> {

  // implement a code to  
  final Api _api = Api();
  FilePickerResult ? result;
  String ? fileName;
  PlatformFile? pickedFile;
  bool isLoading = false;

  File? fileToDisplay;

  bool showProgress = false;

  bool selectAll = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController headerController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String department = "0";
  String grade = "0";

  void pickFile() async{
    try{

      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,

      );
      if(result!=null){
        setState(() {
          isLoading = true;
        });
        fileName = result!.files.first.name;
        pickedFile =result!.files.first;
        fileToDisplay = File(pickedFile!.path!.toString());

      }
    }catch(e){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "The file couldn't upload");
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            SizedBox(

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(MediaQuery.sizeOf(context).height*0.016),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         SizedBox(
                          height: MediaQuery.sizeOf(context).height*0.1,
                        ),

                       Container(
                         alignment: Alignment.center,
                         child:  const Text("Create Notification",
                           style: TextStyle(
                             fontSize: 40,
                             fontWeight: FontWeight.w300,
                             color: Colors.black,

                           ),

                         ),

                       ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height*0.04,
                        ),
                        //Header
                        TextFormField(
                          controller: headerController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Header of Notification',
                            enabled: true,

                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Header cannot be empty";
                            }
                            else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //Body
                        TextFormField(
                          controller: bodyController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Body of Notification',
                            enabled: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius:  BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius:  BorderRadius.circular(10),
                            ),
                          ),
                          minLines: MediaQuery.sizeOf(context).height.toInt() ~/ 70,
                          maxLines: MediaQuery.sizeOf(context).height.toInt() ~/ 65,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Body cannot be empty";
                            }
                            else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),


                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height*0.06,
                              width: MediaQuery.of(context).size.width*0.6,
                              child: DropdownButtonFormField(
                                  decoration: InputDecoration(

                                    filled: true,
                                    fillColor: Colors.white,
                                    enabled: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black),
                                      borderRadius:  BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black),
                                      borderRadius:  BorderRadius.circular(10),
                                    ),
                                  ),
                                  hint: const Text("Department"),
                                  items:
                                  const [
                                    DropdownMenuItem(value: "7",child: Text("Select All"),),
                                    DropdownMenuItem(value: "0",child: Text("Computer E."),),
                                    DropdownMenuItem(value: "1",child: Text("Software E."),),
                                    DropdownMenuItem(value: "2",child: Text("Civil E."),),
                                    DropdownMenuItem(value: "3",child: Text("Electrical and Electronics E."),),
                                    DropdownMenuItem(value: "4",child: Text("Metallurgy and Materials E."),),
                                    DropdownMenuItem(value: "5",child: Text("Geological E."),),
                                    DropdownMenuItem(value: "6",child: Text("Mining E."),),
                                  ], onChanged:  (value){
                                setState(() {
                                  department = value.toString();
                                });}),),

                            SizedBox(
                              width: MediaQuery.sizeOf(context).width*0.02,
                            ),
                            Expanded(
                              child:
                              DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabled: true,


                                    contentPadding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 15.0),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black),
                                      borderRadius:  BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black),
                                      borderRadius:  BorderRadius.circular(5),
                                    ),
                                  ),
                                  hint: const Text("Grade"),
                                  items: const [
                                    DropdownMenuItem(value: "5",child: Text("Select All"),
                                    ),
                                    DropdownMenuItem(value: "0",child: Text("Prep School"),
                                    ),
                                    DropdownMenuItem(value: "1",child: Text("1st Grade"),
                                    ),
                                    DropdownMenuItem(value: "2",child: Text("2nd Grade"),
                                    ),
                                    DropdownMenuItem(value: "3",child: Text("3rd Grade"),
                                    ),
                                    DropdownMenuItem(value: "4",child: Text("4th Grade"),
                                    ),

                                  ], onChanged: (value){
                                setState(() {
                                  grade = value.toString();
                                });
                              }),)
                          ],
                        ),

                        SizedBox(
                          height: MediaQuery.sizeOf(context).height*0.07,
                        ),



                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              elevation: 5.0,
                              height : MediaQuery.sizeOf(context).height*0.06,
                              minWidth: MediaQuery.sizeOf(context).width*0.6,

                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () {
                                pickFile();
                              },
                              color: Colors.white,

                              child: isLoading?
                              Text(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                  fileName!.length < 19 ? fileName! : "${fileName!.substring(0,15)}..." ): const Icon(Icons.attach_file),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child:   MaterialButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                elevation: 5.0,
                                height: MediaQuery.sizeOf(context).height*0.06,
                                minWidth: MediaQuery.sizeOf(context).width*0.3,
                                onPressed: () {

                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      showProgress = true;
                                    });
                                   _api.send_notification("admin",-1,fileName,fileToDisplay, headerController.text,
                                        bodyController.text,grade.toString(),department.toString(),Timestamp.now());
                                  }
                                  else {
                                    setState(() {
                                      showProgress = false;
                                    });
                                  }

                                  _formkey.currentState?.reset();
                                  headerController.clear();
                                  bodyController.clear();
                                  //reset dropdown
                                  department = "0";
                                  grade = "0";
                                  selectAll = false;
                                  setState(() {
                                    showProgress = true;
                                     isLoading = false;
                                  });


                                },
                                color: Colors.white,
                                child: const Text(
                                  "Send",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
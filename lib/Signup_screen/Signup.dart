// import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/login.dart';
// import 'package:flutter_application_1/services/Services.dart';
// import 'package:flutter_application_1/status.dart';
// import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:map_tracking/services/Services.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _Name,_MobileNo,_EmailAddress,_Password;
  final ImagePicker _picker = ImagePicker();
  XFile file;
  String fileName = "";
  String status = '';
  XFile base64Image;
  File tmpFile;
  String imageName = '';
  var errMessage = '';
  @override
  void initState() {
    super.initState();
    initplateForm();
  }

  initplateForm() {
    _Name = new TextEditingController();
    _MobileNo = new TextEditingController();
    _EmailAddress = new TextEditingController();
    _Password = new TextEditingController();
  }

  // List<DropdownMenuItem<Issues>> buildDropdownMenuItems(List issues) {
  //   List<DropdownMenuItem<Issues>> items = List();
  //   for (Issues issue in issues) {
  //     items.add(
  //       DropdownMenuItem(
  //         value: issue,
  //         child: Text(issue.name),
  //       ),
  //     );
  //   }
  //   return items;
  // }

  var datauser = "";



  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
          ),
        ),
        title: Text("Registration"),
      ),

      body: Container(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 50),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          controller: _Name,
                          decoration: InputDecoration(
                            labelText: "Name",
                            icon: const Icon(Icons.person_outline),
                            labelStyle: TextStyle(fontSize: 18),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Name';
                            }
                            return null;
                          },
                          // onFieldSubmitted: ,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _MobileNo,
                          maxLength: 10,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: "Mobile",
                            icon: const Icon(Icons.phone_android),
                            labelStyle: TextStyle(fontSize: 18),
                          ),
                          validator: (value) {
                            if (value.isEmpty ||
                                !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                    .hasMatch(_MobileNo.text)) {
                              return 'Enter Valid Mobile No.';
                            }
                            return null;
                          },
                          // onFieldSubmitted: ,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _EmailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            icon: const Icon(Icons.place),
                            labelStyle: TextStyle(fontSize: 18),
                          ),
                          // onFieldSubmitted: ,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          controller: _Password,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.home_outlined),
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 18),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          // onFieldSubmitted: ,
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: MaterialButton(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.25,
                              color: Colors.deepOrangeAccent,
                              child: Text(
                                "Take Photo",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () => chooseImage())
                      ),
                      MaterialButton(
                          minWidth: MediaQuery.of(context).size.width * 0.25,
                          color: Colors.deepOrangeAccent,
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.

                              uploadingData(
                                  _Name.text,
                                  _MobileNo.text,
                                  _EmailAddress.text,
                                  _Password.text,
                                  base64Image,
                                  fileName);

                              _dailog();

                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                            }
                          })
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }



  _dailog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                children: [
                  Text(
                    'You are registered.\n Please ',
                    style: TextStyle(fontSize: 18, color: Colors.greenAccent),
                  )
                ],
              ),
            ),
          );
        });
  }

  chooseImage() async {
    file = await _picker.pickImage(source: ImageSource.gallery);
    base64Image = file;

    setState(() {
      if (null == file) {
        print('No image selected.');
      } else {
        fileName = file.path;
        print(fileName);
      }
    });
  }

  setStatus(param0) {}
}

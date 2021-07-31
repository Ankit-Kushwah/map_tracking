import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:map_tracking/services/Services.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _Name,_MobileNo,_EmailAddress,_Password;
  String base64Image;
  final ImagePicker _picker = ImagePicker();
  String fileName = "";
  String status = '';
  // File base64Image;
  XFile file;
  String tmpFile;
  String imageName = '';
  var errMessage = '';

  var val='true';
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
                                  fileName,
                                  base64Image
                                  );

                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));

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


  chooseImage() async {

    // final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    file = await _picker.pickImage(source: ImageSource.gallery);

     // tmpFile = file.path;
    final bytes = Io.File(file.path).readAsBytesSync();

    base64Image = base64Encode(bytes);

    setState(() {
      if (file==null) {
        print('No image selected.');
      } else {
        fileName = file.path.split('/').last;
      }
    });
  }

  setStatus(param0) {}
}



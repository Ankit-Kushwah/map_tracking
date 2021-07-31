import 'dart:convert';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_tracking/Signup_screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';



String path ="https://morenanigam.000webhostapp.com/MorenaNigam1/Testing/index.php/Testing/";
String Imagepath ="https://morenanigam.000webhostapp.com/MorenaNigam1/Testing/upload/";

 uploadingData(
    String Name,
    String MobileNo,
    String EmailAddress,
    String Password,
    String fileName,
    String base64image,
    // File base64image

    ) async {
  var dio = new Dio();
  FormData formData = new FormData.fromMap({
    "Name": Name,
    "MobileNo": MobileNo,
    "EmailAddress": EmailAddress,
    "Password": Password,
    "image": base64image,
    "name": fileName
  });
  try {
    Response response1 = await dio.post(path + "register", data: formData);

    var userdata = json.decode(response1.data.toString());

    return userdata;
  } catch (e) {
    print( e.toString());
  }
}

remove(context) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.remove("User_Id");
  prefs.remove("Name");
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );
}

onLoading() {
  StatefulBuilder(
    // ignore: missing_return
    builder: (context, setState) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .4,
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(),
                  new SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          );
        },
      );
      new Future.delayed(new Duration(seconds: 1), () {
        Navigator.pop(context); //pop dialog
      });
    },
  );
}

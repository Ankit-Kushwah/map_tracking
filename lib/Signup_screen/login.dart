import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:map_tracking/services/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'MapScreen.dart';
import 'Signup.dart';


void main() => runApp(new MyApp());
Map<int, Color> color = {
  50: Color.fromRGBO(4, 170, 176, .1),
  100: Color.fromRGBO(4, 170, 176, .2),
  200: Color.fromRGBO(4, 170, 176, .3),
  300: Color.fromRGBO(4, 170, 176, .4),
  400: Color.fromRGBO(4, 170, 176, .5),
  500: Color.fromRGBO(4, 170, 176, .6),
  600: Color.fromRGBO(4, 170, 176, .7),
  700: Color.fromRGBO(4, 170, 176, .8),
  800: Color.fromRGBO(4, 170, 176, .9),
  900: Color.fromRGBO(4, 170, 176, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF04AAB0, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: colorCustom,
      ),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  FormType _form = FormType.login;

  var responseJson;
  var Email = "";
  var Gid = "";
  var Mobile = "";
  var Address = "";
  var Last_Name = "";
  var First_Name = "";
  var Field = "";

  var id = "";

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form == FormType.register;
      } else {
        _form = FormType.login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              _buildTextFields(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Login"),
      centerTitle: true,
    );
  }



  Widget _buildTextFields() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 62, 0, 0),
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
              child: MaterialButton(
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.deepOrangeAccent,
                  ),
                  padding: const EdgeInsets.fromLTRB(30, 8, 10, 2),
                  child: const Text('LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
                onPressed: () async {
                  _loginPressed();
                },
              ),
            ),
            SizedBox(height: 100),
            new MaterialButton(
                child: new Text('SignUp'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                }),
            new MaterialButton(
                child: new Text('Map'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Mappage()),
                  );
                }),
          ],
        ),
      );
    }
  }

  _loginPressed() async {
    var dio = new Dio();
    FormData formData = new FormData.fromMap({
      "User_id":_email,
      "Password":_password
    });
    var res =await dio.post(path + "login", data: formData);
    // print(path + 'login?User_id=$_email&Password=$_password');
    setState(() {

      responseJson = json.decode(res.data.toString());
    });

    print(responseJson.toString());
    print(responseJson['status']);

    setState(() {
      if (responseJson['status'] != true) {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Officer Panel'),
              content: Container(
                child: Text('This Login is only for\n Government official'),
              ),
              actions: <Widget>[
                TextButton(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color.fromRGBO(4, 170, 176, 1),
                          Color.fromRGBO(3, 205, 172, 1)
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mappage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        setdata();
      }
    });
  }

  setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("Ward_No", responseJson['Officer_Ward']);
    prefs.setString("User_Id", responseJson['User_id']);
    prefs.setString("Name", responseJson['Name']);

    // _onLoading();
  }
  //
  // void _onLoading() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           height: MediaQuery.of(context).size.height * .2,
  //           width: MediaQuery.of(context).size.width * .4,
  //           child: new Column(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               new CircularProgressIndicator(),
  //               new SizedBox(
  //                 height: 5.0,
  //               ),
  //               new Text("Loading"),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   new Future.delayed(new Duration(seconds: 3), () {
  //     Navigator.pop(context); //pop dialog
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Panel()));
  //   });
  // }
}
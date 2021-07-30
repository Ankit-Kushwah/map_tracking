import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String id='';
  String auther='';
  String cwigth='';
  String cheight='';
  var down='';
  getimages() async {
    final response = await http.get(Uri.parse("https://picsum.photos/v2/list"));
    var res = jsonDecode(response.body);

    print(" Return");
    print(res);
    print(res.length);


setState(() {
  for (int i = 0; i < res.length; i++) {
    if (res[i]['id'] == "997") {
      id = res[i]['id'];
      auther = res[i]['author'];
      cwigth = res[i]['width'].toString();
      cheight = res[i]['height'].toString();
      down = res[i]['download_url'];
      print("Ankit "+auther);

    }
    else if (i == res.length-1) {
      id = res[i]['id'];
      auther = res[i]['author'];
      cwigth = res[i]['width'].toString();
      cheight = res[i]['height'].toString();
      down = res[i]['download_url'];
      print("Ankit "+auther);
      print("Ankit "+down);
    }
  }

});



  }

  loader() {
    return new Container(
      child: Center(
        child: Text("Loading", style: TextStyle(fontSize: 24),),
      ),
    );

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getimages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(auther, style: TextStyle(fontSize: 24.0),),
        ),
      ),
      body:down==""? loader() :GridView.builder(
        scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(down,width: double.parse(cwigth),height: double.parse(cheight),);
          }
      ),
    );
  }
}

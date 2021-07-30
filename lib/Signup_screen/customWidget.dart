import 'dart:convert';
import 'package:http/http.dart' as http;

String id;
String auther;
double cwigth;
double cheight;
String down;
getimages() async {
  final response = await http.get(Uri.parse("https://picsum.photos/v2/list"));
  var res = jsonDecode(response.body);
  int count = 0;

  if (res['status'] == 200) {
    for (int i = 0; i < res.length; i++) {
      if (res[i]['id'] == "997") {
        id = res[i]['id'];
        auther = res[i]['author'];
        cwigth = res[i]['width'];
        cheight = res[i]['height'];
        down = res[i]['download_url'];
        count = 1;
      }
      else if (count == 0 && i >res.length-1) {
        id = res[i]['id'];
        auther = res[i]['author'];
        cwigth = res[i]['width'];
        cheight = res[i]['height'];
        down = res[i]['download_url'];
      }
    }
    return res;
  }
}





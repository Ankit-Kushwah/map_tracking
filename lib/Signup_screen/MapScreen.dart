import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_tracking/services/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProfileScreen.dart';
import 'login.dart';



class Mappage extends StatefulWidget
{
  Mappage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MappageState createState() => _MappageState();
}


class _MappageState extends State<Mappage> {

  StreamSubscription _locationSubscription;
  Location _locationTracker = new Location();
  Marker marker;
  Circle circle;
  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.2183, 78.1828),
    zoom: 14.4746,
  );

  String username;

  String imageid;

  @override
  void dispose(){
    super.dispose();
    if(_locationSubscription != null){
      _locationSubscription.cancel();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    print("working");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:80.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius:30.0 ,
                backgroundImage:NetworkImage(Imagepath+imageid)
//"scaled_0d3d1d99-ee78-48b1-bff8-f7d9230cffea3944150467549545739.jpg"
            ),
            SizedBox(width: 10),
            Text(username),
            SizedBox(width: 100),
            MaterialButton(
                child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.white)),
                onPressed:()async{
                  SharedPreferences prefs= await SharedPreferences.getInstance();
                  prefs.remove('Image');
                  prefs.remove('Name');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                        (route) => false,
                  );

                } )
          ],
        ),
      ),
      body:GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          // initialCameraPosition: _kGooglePlex,
          markers: Set.of((marker != null)?[marker]:[]),
          circles: Set.of((circle != null)?[circle]:[]),
          onMapCreated: (GoogleMapController controller) {
            controller1 = controller;
          }
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          onPressed: getCurrentLocation,
          child: Icon(Icons.location_searching),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.

      bottomNavigationBar:TextButton(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text('Profile', style: TextStyle(fontSize: 20,color: Colors.white)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
      ) ,

    );
  }


  Future<Uint8List> getMarker() async {
    ByteData byteData=await DefaultAssetBundle.of(context).load("assets/locationPointer.png");
    return byteData.buffer.asUint8List();
  }


  void getCurrentLocation()async
  {
    try{
      var icon= await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location,icon);
      if(_locationSubscription != null){
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((locationData){
        if(controller1 !=null){
          controller1.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(locationData.latitude, locationData.longitude),
              tilt: 0,
              zoom: 18.00
          )));
        }

      });

    }on PlatformException catch(e){
      if(e.code=="PERMISSION_DENIED"){
        debugPrint("Permission Denied");
      }
    }
  }


  void updateMarkerAndCircle(LocationData locationData, Uint8List icon) {
    LatLng latlng = LatLng(locationData.latitude,locationData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId('home'),
          position: latlng,
          rotation: locationData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5,0.5),
          icon:BitmapDescriptor.fromBytes(icon)
      );
      circle = Circle(
          circleId: CircleId("person"),
          radius: locationData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.black26
      );
    });
  }

  void getdata() async{

    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(() {
      username=prefs.getString('Name')??"";
      imageid=prefs.getString('ImageName')??"";
      print(imageid);
    });

  }






}
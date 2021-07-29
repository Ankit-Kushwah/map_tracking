import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Map Track'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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

  @override
  void dispose(){
    super.dispose();
    if(_locationSubscription != null){
      _locationSubscription.cancel();
    }
  }

  String currentcountry;

  var currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
      floatingActionButton: FloatingActionButton(
        onPressed: getCurrentLocation,

        child: Icon(Icons.location_searching),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Future<Uint8List> getMarker() async {
    ByteData byteData=await DefaultAssetBundle.of(context).load("assets/locationPointer.jpg");
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






}

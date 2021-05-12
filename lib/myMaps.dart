import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Mapas extends StatefulWidget {
  @override
  _MapasState createState() => _MapasState();
}

class _MapasState extends State<Mapas> {
  Completer <GoogleMapController> _controller = Completer();

  static final CameraPosition _posicaoPraia = CameraPosition(
    bearing: 150,
    target: LatLng(-28.128324, -48.641535),
    tilt: 59.44,
    zoom: 18.15
  );
  static final CameraPosition _posicaoInicial = CameraPosition(
    target: LatLng(-23.600943,-48.051553),
    zoom: 19.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Exemplo Mapas"),
        actions: [
          IconButton(
            color: Colors.red,
            icon: Icon(
              Icons.pin_drop,
            ),
            onPressed: _goToTheBeach,
          ),
          IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: _suaCasa,
          ),

        ],
      ),
      body: _mapaExemplo(),
    );
  }
  _mapaExemplo() {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.satellite,
        markers:{fatecMark},
        initialCameraPosition: _posicaoInicial,
        onMapCreated:(GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
    );
  }
  Marker fatecMark = Marker(
    markerId: MarkerId('Fatec Itape'),
    position: LatLng(-23.600941,-48.05151),
    infoWindow: InfoWindow(title: 'Fatec Itape'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueCyan,
    ),
    onTap:(){
      print("oi");
    }
  );
  Future<void> _goToTheBeach() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_posicaoPraia));
  }

 Future<void> _suaCasa() async{
  final GoogleMapController controller =await _controller.future;
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled= await location.serviceEnabled();

    if (!_serviceEnabled){
      _serviceEnabled =  await location.requestService();
      if (!_serviceEnabled){
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted ==PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    _locationData = await location.getLocation();

    CameraPosition _posicaoGPS = CameraPosition(
      target: LatLng(_locationData.latitude,_locationData.longitude),
      zoom:19.5,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_posicaoGPS));

  }
}

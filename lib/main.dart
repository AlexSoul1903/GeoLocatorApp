import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main(){

  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      title: "Maps Locator App",
      home: MyHomePage(),
    );

  }
}

class MyHomePage extends StatefulWidget{

  @override
  _MyHomePageState createState()=>_MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  String _nom="";
  String _ape="";
  double _latitud=0.0;
  double _longitud=0.0;

  @override
  Widget build (BuildContext context){

    return Scaffold(

      appBar: AppBar(title: Text('Maps Locator App'),),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(

              decoration: InputDecoration(labelText: 'Nombre'),
              onChanged:(value){
                _nom=value;
              } ,
            ),

            TextField(

              decoration: InputDecoration(labelText: 'Apellido'),
              onChanged:(value){
                _ape=value;
              } ,
            ),
            TextField(

              decoration: InputDecoration(labelText: 'Latitud'),
              onChanged:(value){
                _latitud=double.parse(value);
              } ,
            ),
            TextField(

              decoration: InputDecoration(labelText: 'Longitud'),
              onChanged:(value){
                _longitud=double.parse(value);
              } ,
            ),

            TextButton(

            child: Text('Ver Mapa'),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> MapPage(

                    nom: _nom,
                    ape: _ape,
                    latitud: _latitud,
                    longitud: _longitud,

                  ) ),);

            },

            ),



          ],

        ),

      ) ,

    );

  }

}

class MapPage extends StatefulWidget {

  final String nom;
  final String ape;
  final double longitud;
  final double latitud;

  MapPage({

    required this.nom,
    required this.ape,
    required this.latitud,
    required this.longitud,

  });

  @override
  _MapPageState createState()=>_MapPageState();
}

class _MapPageState extends State<MapPage> {

  String _ciudadPais='Cargando...';

  @override
  void initState(){

    super.initState();
    _getCiudadPais();
  }

  Future<void>_getCiudadPais() async{

    String ciudadPais= await _fetchCiudadPais(widget.latitud, widget.longitud);

    setState(() {
      _ciudadPais= ciudadPais;
    });

  }
  Future<String>_fetchCiudadPais(double latitud, double longitud) async{

    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(latitud,longitud);
      if(placemarks.isNotEmpty){
        Placemark placemark = placemarks.first;
        String ciudad = placemark.locality ?? '';
        String pais = placemark.country ?? '';

        return ciudad.isNotEmpty ? ciudad : pais;
      }else{

        return 'Desconocido';
      }
    }catch(e){
      return 'Desconocido';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text('Map'),
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitud, widget.longitud),
          zoom: 15,
        ),
        markers: Set<Marker>.of(
          [
            Marker(
              markerId: MarkerId(widget.nom),
              position: LatLng(widget.latitud, widget.longitud),
              infoWindow: InfoWindow(
                title:  widget.nom,
                snippet: '${widget.ape}, $_ciudadPais',
              ),

            ),

          ],

        ),
      ),

    );
  }
}






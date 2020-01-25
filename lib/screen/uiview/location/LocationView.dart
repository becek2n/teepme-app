
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:teepme/bloc/Transaksi/LocationBloc.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class LocationView extends StatefulWidget {
  final LocationBloc bloc;
  const LocationView(
      {Key key, this.bloc})
      : super(key: key);
  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView>{
  PanelController _pc = new PanelController();

  GoogleMapController mapController;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    widget.bloc.onGetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: MainAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: slidingUpPanel(),
      ),
    );
    
  }
  /*
  void addMarker(){
    if (widget.bloc.currentState.locationList != null){
      setState(() {
        for(int i = 0; i < widget.bloc.currentState.locationList.length; i++){
          marker.add(
            Marker(
              markerId: MarkerId("curr_loc"),
              position: LatLng(widget.bloc.currentState.locationList[i].latitude, widget.bloc.currentState.locationList[i].longitude),
              infoWindow: InfoWindow(
                title: widget.bloc.currentState.locationList[i].name, snippet: widget.bloc.currentState.locationList[i].name
              )
            )
          );
        }
      });
    }
  }
  */

  
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.250580, 106.826238),
    zoom: 14.4746,
  );

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  

  Widget slidingUpPanel(){
    BorderRadiusGeometry radius = BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0));
    return BlocBuilder(
      bloc: widget.bloc,
      builder: (BuildContext context, LocationState state) {
        final List<Marker> marker = <Marker>[];
        if (state.locationList == null){
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpinKitRing(color: Colors.lightGreenAccent),
              ],
          );
        }else{
          if (state.locationList != null){
            for(int i = 0; i < state.locationList.length; i++){
              double d = double.parse(state.locationList[i].longitude.toStringAsFixed(6));
              print(d);
              marker.add(
                Marker(
                  markerId: MarkerId("1"),
                  position: new LatLng(state.locationList[i].latitude, d ),
                  infoWindow: InfoWindow(
                    title: state.locationList[i].name, snippet: state.locationList[i].name
                  ),
                )
              );
            }
            
          }
          
          marker.add(
                Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(-6.250580, 106.826238),
                  infoWindow: InfoWindow(
                    title: "Your Location", snippet: "Your"
                  ),
                )
              );
          /*
          marker.add(
                Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(-6.257033, 106.855983),
                  infoWindow: InfoWindow(
                    title: "Plaza Kalibata"
                  ),
                )
              );
          marker.add(
                Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(-6.257033, 106.855983),
                  infoWindow: InfoWindow(
                    title: "Plaza Kalibata", snippet: "Kalibata"
                  ),
                )
              );
          */
          return SlidingUpPanel(
            controller: _pc,
            backdropEnabled: true,
            borderRadius: radius,
            panel: mapList(),
            collapsed: Container(
              margin: const EdgeInsets.only(top: 0.0),
              decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
              child: Icon(Icons.drag_handle),
            ),
            body: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              //markers: Set<Marker>.of(marker),
              markers: Set<Marker>.of(marker),
            ),
          );
        }
        
        
      }
    );
    
  }

  Widget mapList(){
    return BlocBuilder(
      bloc: widget.bloc,
      builder: (context, LocationState state) {
        if (state.locationList == null){
          return Container();
        }
        return Container(
          margin: const EdgeInsets.only(top: 36.0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    widget.bloc.onGetData();
                    widget.bloc.onSearchLocation(value, state.locationList);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.location_on, size: 50.0,)
                              ],
                            )
                          ),
                          new Expanded(
                            child: new Padding(
                              padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(state.locationList[index].name, style: TextStyle(fontSize: 20)),
                                  new Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    child: new Text(state.locationList[index].address),
                                  ),
                                ],
                              )
                            ),
                          ),                  
                        ],
                      ),
                    ),
                  );
                },
                itemCount: state.locationList.length,
                ),
              )
            ]
          )
        );
      }
    );
  }
  
  /*
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  */
}
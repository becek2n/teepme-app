import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainKebutuhanScreen extends StatefulWidget{
  const MainKebutuhanScreen({ Key key }) : super(key: key);
  @override
  _MainKebutuhanScreenState createState() => _MainKebutuhanScreenState();
}

class _MainKebutuhanScreenState extends State<MainKebutuhanScreen>{
  @override
  Widget build(BuildContext context){
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      delegate: SliverChildListDelegate(
        [
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/gold-1.png", width: 65.0, alignment: Alignment.centerLeft, ),
                  new Text("Buka Emas")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/grosir.png", width: 50.0, alignment: Alignment.centerLeft, ),
                  new Text("Buka Grosir")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/phone.png", width: 50.0, alignment: Alignment.centerLeft, ),
                  new Text("Pulsa Prabayar")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/insurance.png", width: 65.0, alignment: Alignment.centerLeft, ),
                  new Text("Buka Asuransi")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/gold-1.png", width: 65.0, alignment: Alignment.centerLeft, ),
                  new Text("Buka Emas")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/grosir.png", width: 50.0, alignment: Alignment.centerLeft, ),
                  new Text("Buka Grosir")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/phone.png", width: 50.0, alignment: Alignment.centerLeft, ),
                  new Text("Pulsa Prabayar")
                ],
              )
            )
          ),
          Card(
            child: new Padding(
              padding: new EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  new Image.asset("lib/assets/images/insurance.png", width: 65.0, alignment: Alignment.centerLeft, ),
                  new Text("Buka Asuransi")
                ],
              )
            )
          ),
        ]
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainMenuScreen extends StatefulWidget{
  const MainMenuScreen({ Key key }) : super(key: key);
  @override
  _HeaderScreenState createState() => _HeaderScreenState();
}

class _HeaderScreenState extends State<MainMenuScreen>{
  List<String> items = [
  "TeepMart",
  "Tukar uang",
  "Teep Booth",
  "Nearby",
  ];

  List imgHeaderIcon = [
    "lib/assets/images/mart.png",
    "lib/assets/images/money-exchange.png",
    "lib/assets/images/booth.png",
    "lib/assets/images/nearby.png",
  ];

  @override
  Widget build(BuildContext context){
    final _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: new EdgeInsets.only(top: 10.0),
      child: new Container(
        padding:  new EdgeInsets.only(top: 8.0),
        color: Colors.white,
        height: 90.0, 
        width: _width, 
        child: headerList(context)
      )
    );
  }

  Widget headerList (BuildContext context){ 
    return new Center(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          EdgeInsets padding = index == 0?const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0):const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0);
          return new Padding(
            padding: padding,
            child: new InkWell(
              onTap: () {
                print('Card selected');
              },
              child: new Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.white,
                  image: new DecorationImage(
                    image: new AssetImage(imgHeaderIcon[index]),
                    fit: BoxFit.fill),
                    ),
                width: 70.0,
                child: new Stack(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.bottomCenter,
                      child: new Container(
                        decoration: new BoxDecoration(
                        color: const Color(0xFF273A48),
                        borderRadius: new BorderRadius.only(
                          bottomLeft: new Radius.circular(10.0),
                          bottomRight: new Radius.circular(10.0)
                          )
                        ),
                      height: 20.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            items[index],
                            style: new TextStyle(color: Colors.white, fontSize: 10.0),
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      )
    );
  }
}


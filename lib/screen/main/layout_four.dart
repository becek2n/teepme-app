import 'package:flutter/material.dart';

class MainKursNewsScreen extends StatefulWidget{
  const MainKursNewsScreen({ Key key }) : super(key: key);
  @override 
  _MainKursNewsScreenState createState() => _MainKursNewsScreenState();
}

class _MainKursNewsScreenState extends State<MainKursNewsScreen>{
  List _currency = [
    {"image": "lib/assets/images/flag-usd.png", "currencyName": "USD", "nilaiJual" : "14.000", "nilaiBeli" : "13.000"},
    {"image": "lib/assets/images/flag-uad.png", "currencyName": "UAD", "nilaiJual" : "13.000", "nilaiBeli" : "12.000"},
    {"image": "lib/assets/images/flag-sgd.png", "currencyName": "SGD", "nilaiJual" : "12.000", "nilaiBeli" : "11.000"},
    {"image": "lib/assets/images/flag-jpy.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
  ];

  @override
  Widget build(BuildContext context){
    final _width = MediaQuery.of(context).size.width;
    // the Expanded widget lets the columns share the space
    return new Padding(
      padding: new EdgeInsets.only(top: 10.0),
      child: new Container(
        padding:  new EdgeInsets.only(top: 8.0),
        color: Colors.white,
        //height: 400, 
        width: _width, 
        child: new Stack(
        children: <Widget>[
          new Padding(
            padding:  new EdgeInsets.only(top: 5.0, left: 20.0),
            child:new Text(
              'Nilai Tukar Saat Ini',
              style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            )  
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 40.0),
            child: new Container(
              padding:  new EdgeInsets.only(top: 8.0),
              color: Colors.white,
              //height: 300.0, 
              child: _listData(context)
            )
          )
          ]
        )
      )
    ); 
  }
  _column(String name, String value){
   return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Text(name),
        ],
      ),
    );
  } 
  Widget _listData (BuildContext context){
        return new Center(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(right: 10.0),
                        child: Column(
                          children: <Widget>[
                            new Image.asset(_currency[index]["image"], width: 40.0, alignment: Alignment.centerLeft, ),
                          ],
                        )
                      ),
                      _column("", _currency[index]["currencyName"]),
                      _column("Jual", _currency[index]["nilaiJual"]),
                      _column("Beli", _currency[index]["nilaiBeli"]),
                    ],
                  ),
                ),
              );
            },
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _currency.length,
          shrinkWrap: true,
          )
        );
      }
}
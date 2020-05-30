import 'package:flutter/material.dart';
import 'package:teepme/Repositories/ScrapCurrencyRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/ScrapCurrencyModel.dart';


class CurrencyUpdateView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;

  const CurrencyUpdateView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _CurrencyUpdateState createState() => _CurrencyUpdateState();
}

class _CurrencyUpdateState extends State<CurrencyUpdateView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List _currency = [
    {"image": "lib/assets/images/flag-usd.png"},
    {"image": "lib/assets/images/flag-uad.png"},
    {"image": "lib/assets/images/flag-sgd.png"},
    {"image": "lib/assets/images/flag-jpy.png"},
  ];
  List<ScrapCurrencyModel> _scrapCurrency = <ScrapCurrencyModel>[];
  
  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    
    if (!mounted) return;
    APIWeb().load(ScrapCurrencyRepository.getData).then((scrapCurrencyData) => {
      setState(() => {
        _scrapCurrency = scrapCurrencyData
      })
    });
    
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return  AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Padding(
                  padding: new EdgeInsets.only(top: 10.0),
                  child: new Container(
                    padding:  new EdgeInsets.only(top: 8.0),
                    color: Colors.white,
                    //height: 400, 
                    width: _width, 
                    child: new Stack(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(top: 0.0),
                        child: new Container(
                          padding:  new EdgeInsets.only(top: 0.0),
                          color: Colors.white,
                          //height: 300.0, 
                          child: _listData(context)
                        )
                      )
                      ]
                    )
                  )
                ),
            ),
          ),
        );
      },
    );
  }

  _column(String name, String value){
   return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
          Text(name),
        ],
      ),
    );
  } 
  Widget _listData (BuildContext context){
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Container();
        }
        else{
          return Center(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0){
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child:
                          new Text("Currency",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 65.0, bottom: 20.0),
                          child:new Text("Max",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 58.0, bottom: 20.0),
                          child:new Text("Average",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, bottom: 20.0),
                          child:new Text("Volume",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ]
                    );
                  }
                index -=1;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 10.0, left: 5.0, right: 5.0),
                    //padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.only(right: 10.0, bottom: 13.0),
                          child: Column(
                            children: <Widget>[
                              new Image.asset(_currency[index]["image"], width: 30.0, alignment: Alignment.centerLeft, ),
                            ],
                          )
                        ),
                        _column("",  _scrapCurrency[index].name),
                        _column("", _scrapCurrency[index].max),
                        _column("", _scrapCurrency[index].average),
                        _column("", _scrapCurrency[index].volume),
                      ],
                    ),
                  ),
                );
              },
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _scrapCurrency.length + 1,
            shrinkWrap: true,
            )
          );  
        }
      }
    );
        
  }
}

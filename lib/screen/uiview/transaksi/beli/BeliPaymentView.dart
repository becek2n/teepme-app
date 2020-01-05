import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:teepme/Repositories/ScrapCurrencyRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/ScrapCurrencyModel.dart';


class BeliPaymenView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;

  const BeliPaymenView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _BeliPaymenViewState createState() => _BeliPaymenViewState();
}

class _BeliPaymenViewState extends State<BeliPaymenView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List _payment = [
    {"image": "lib/assets/images/bri-logo.png", "name" : "BRI", "text" : "Pay easily with BRI"},
    {"image": "lib/assets/images/mandiri-logo.png", "name" : "Mandiri", "text" : "Pay easily with Mandiri"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
    {"image": "lib/assets/images/permata-logo.png", "name" : "Permata", "text" : "Pay easily with Permata"},
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
                    width: _width, 
                    child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(top: 0.0),
                        child: new Container(
                          padding:  new EdgeInsets.only(top: 0.0),
                          color: Colors.white,
                          //height: 300.0, 
                          child: Column(
                            children: <Widget>[
                              _listData(context),
                            ],
                          ) 
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

  Widget _listData (BuildContext context){
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitRing(color: Colors.lightGreenAccent),
            ],
          );
        }
        else{
          return Center(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return  Container(
                  child: Card( 
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 5.0, right: 5.0),
                      child: ListTile(
                        leading: SizedBox(
                            child: Image.asset(_payment[index]["image"], width: 80.0, alignment: Alignment.centerLeft,)
                          ),
                        title: Text(_payment[index]["text"], style: TextStyle(color: Colors.blueGrey)),
                        //subtitle: Text(_payment[index]["text"]),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {},
                        selected: true,
                      )
                    ),
                  ),
                );
              },
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _payment.length,
            shrinkWrap: true,
            )
          );  
        }
      }
    );
        
  }
}

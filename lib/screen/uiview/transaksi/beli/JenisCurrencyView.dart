import 'package:flutter/material.dart';
import 'package:teepme/models/RadioModel.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class JenisCurrencyView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;

  const JenisCurrencyView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _JenisCurrencyViewState createState() => _JenisCurrencyViewState();
}

class _JenisCurrencyViewState extends State<JenisCurrencyView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  
  List<RadioModel> sampleData = new List<RadioModel>();

  List _currency = [
    {"image": "lib/assets/images/flag-usd.png", "currencyName": "USD", "nilaiJual" : "14.000", "nilaiBeli" : "13.000"},
    {"image": "lib/assets/images/flag-uad.png", "currencyName": "UAD", "nilaiJual" : "13.000", "nilaiBeli" : "12.000"},
    {"image": "lib/assets/images/flag-sgd.png", "currencyName": "SGD", "nilaiJual" : "12.000", "nilaiBeli" : "11.000"},
    {"image": "lib/assets/images/flag-jpy.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
    {"image": "lib/assets/images/flag-sgd.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
    {"image": "lib/assets/images/flag-jpy.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
    {"image": "lib/assets/images/flag-sgd.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
    {"image": "lib/assets/images/flag-jpy.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
    {"image": "lib/assets/images/flag-sgd.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
    {"image": "lib/assets/images/flag-jpy.png", "currencyName": "JPY", "nilaiJual" : "11.000", "nilaiBeli" : "10.000"},
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
    sampleData.add(new RadioModel(false, 'A', 'April 18'));
    sampleData.add(new RadioModel(false, 'B', 'April 17'));
    sampleData.add(new RadioModel(false, 'C', 'April 16'));
    sampleData.add(new RadioModel(false, 'D', 'April 15'));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    _currency.length,
                    (index) {
                      var count = _currency.length;
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return AreaView(
                        imagepath: _currency[index]["image"],
                        animation: animation,
                        animationController: animationController,
                        imageText: _currency[index]["currencyName"],
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  final String imagepath;
  final String imageText;
  final AnimationController animationController;
  final Animation animation;

  const AreaView({
    Key key,
    this.imagepath,
    this.imageText,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: MainAppTheme.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: MainAppTheme.grey.withOpacity(0.4),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  splashColor: MainAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => new DetailPage(data: null)));
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => new BeliView(animationController: animationController,)));
                    
                  },
                  child: 
                  
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                        child: Image.asset(imagepath),
                      ),
                      Text(
                        imageText,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: MainAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: MainAppTheme.lightText,
                        ),
                        
                      ),

                    ],
                  ),
                  
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


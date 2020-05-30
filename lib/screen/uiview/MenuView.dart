import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teepme/bloc/Master/CurrencyBloc.dart';
import 'package:teepme/bloc/Master/PaymentBloc.dart';
import 'package:teepme/bloc/Transaksi/BeliBloc.dart';
import 'package:teepme/bloc/Transaksi/BuyBloc.dart';
import 'package:teepme/bloc/Transaksi/LocationBloc.dart';
import 'package:teepme/main.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BuyView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class MenuView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;

  const MenuView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<String> areaListData = [
    "assets/fitness_app/area1.png",
    "assets/fitness_app/area3.png",
    "assets/fitness_app/area1.png",
  ];

  List<String> areaListDataText = [
    "Buy",
    "Sell",
    "History",
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
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
              aspectRatio: 3.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    areaListData.length,
                    (index) {
                      var count = areaListData.length;
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return AreaView(
                        imagepath: areaListData[index],
                        animation: animation,
                        animationController: animationController,
                        imageText: areaListDataText[index],
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
                      if (imageText == "Buy"){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                            
                            new BlocProvider<BuyBloc>(
                              builder: (BuildContext context) => BuyBloc(),
                              child: BlocProvider<CurrencyBloc>(
                                builder: (BuildContext context) => CurrencyBloc(),
                                child: BlocProvider<LocationBloc>(
                                  builder: (BuildContext context) => LocationBloc(),
                                  child: BlocProvider<PaymentBloc>(
                                    builder: (BuildContext context) => PaymentBloc(),
                                    child: BuyView(animationController: animationController)
                                  )
                                )
                              )
                            )
                            /*new BlocProvider<BeliBloc>(
                              builder: (BuildContext context) => BeliBloc(),
                              child: BlocProvider<CurrencyBloc>(
                                builder: (BuildContext context) => CurrencyBloc(),
                                child: BlocProvider<LocationBloc>(
                                  builder: (BuildContext context) => LocationBloc(),
                                  child: BlocProvider<PaymentBloc>(
                                    builder: (BuildContext context) => PaymentBloc(),
                                    child: BeliView(animationController: animationController)
                                  )
                                )
                              )
                            )*/
                          )
                        );
                      }
                      if(imageText == "History"){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                            new MyHomePage(title: '', form: "history",) 
                          )
                        );
                        /*
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                            new BlocProvider<TransactionBloc>(
                              builder: (BuildContext context) => TransactionBloc(),
                              child: TransactionHistoryView(animationController: animationController) 
                            )
                          )
                        );
                        */
                      }
                    },
                    child: Column(
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

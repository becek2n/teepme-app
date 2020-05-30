import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class AppBarMainScreen extends StatefulWidget {
  final AnimationController animationController;
  final double topBarOpacity;

  const AppBarMainScreen({Key key, this.animationController, this.topBarOpacity}) : super(key: key);
  @override
  _AppBarMainScreenState createState() => _AppBarMainScreenState();
}

class _AppBarMainScreenState extends State<AppBarMainScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  //double topBarOpacity = 0.0;

  String _dateFormat;

  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    
    var _dateNow = new DateTime.now();
    _dateFormat = (new DateFormat("dd MMM yyyy").format(_dateNow));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getAppBarUI(); 
  }


  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MainAppTheme.white.withOpacity(widget.topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: MainAppTheme.grey
                              .withOpacity(0.4 * widget.topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * widget.topBarOpacity,
                            bottom: 12 - 8.0 * widget.topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "TeepMe",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: MainAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * widget.topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: MainAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: MainAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

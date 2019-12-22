import 'package:flutter/material.dart';
import 'package:teepme/main.dart';
import 'package:teepme/theme/MainAppTheme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BeliConfirmView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;

  const BeliConfirmView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _BeliConfirmViewState createState() => _BeliConfirmViewState();
}

class _BeliConfirmViewState extends State<BeliConfirmView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  //String _currencyController;

  bool visibilityFormResult = false;
  String currencyResult = "";
  List<Widget> listViews = List<Widget>();


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
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              formConfirm(searchCurrencyView(_currency),
                BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(60.0))
              ),
              SizedBox(
                height: 20.0,
              ),
              formConfirm(
                Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 100,
                                right: 16,
                                top: 40,
                              ),
                            ),
                            Text("Search for booth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            
                          ],
                        ),
                        
                      ],
                    ),
                  ],
                ),
                BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0))
              ),
              SizedBox(
                height: 20.0,
              ),

              formConfirm(
                Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 0.0,
                                right: 16.0,
                                top: 40.0,
                              ),
                            ),
                            Text("Duration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 8, bottom: 8),
                            child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded( // Constrains AutoSizeText to the width of the Row
                              child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right:10.0
                              ),
                              child: AutoSizeText(
                                  "Normal (Free of Charge)",
                                  maxLines:2,
                                )
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right:10.0
                              ),
                              child: RaisedButton(
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: new Text('Change Duration'),
                              ),
                            ),
                          ]
                        ),
                        new Row(
                          children: <Widget>[
                            Expanded( // Constrains AutoSizeText to the width of the Row
                              child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right:10.0
                              ),
                              child: AutoSizeText(
                                "You can pick up your purchase at booth on (05-12-2019) (3 days from now).",
                                maxLines:2,
                              )
                              )
                            ),
                          ]
                        ),
                      ],
                    ),
                    
                  ],
                ),
                BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0))
              ),

              SizedBox(
                height: 20.0,
              ),

              formConfirm(
                Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 100,
                                right: 16,
                                top: 40,
                              ),
                            ),
                            Text("Total IDR 9.700.000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0))
              ),

              SizedBox(
                height: 20.0,
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('Add More Currency'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('Book'),
                  ),
                ]
              ),

            ],
          ),
        );
      },
    );
  }
  
  Widget formConfirm(Widget widgetForm, BorderRadius borderRadius) {
    return new Container(
      padding: const EdgeInsets.only(top: 0.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          MainAppTheme.white,
          HexColor("#FFFFFF")
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: MainAppTheme.grey.withOpacity(0.6),
              offset: Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            widgetForm,
          ],
        ),
      ),
    );
  }
  /*
  void _searchCurrency() {
    setState(() {
      visibilityFormResult = true;
      currencyResult = "partial";
    });    
  }
  */
  List _currency = [
    {"volume": "500", "rate" : "13.800", "total" : "6.900.000"},
    {"volume": "200", "rate" : "14.000", "total" : "2.800.000"},
  ];
  
  _column(String isSuggestion, String value){
   return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
           (isSuggestion == "true") ? RaisedButton(
                  onPressed: () {},
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('Take'),
                ) : Text(""),
        ],
      ),
    );
  }

  Widget searchCurrencyView(List dataCurrency){
    if (dataCurrency.length > 0){
      return new Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0){
              return Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child:new Text("Volume",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child:new Text("Rate",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ]
              );
            }
            index -=1;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: <Widget>[
                    _column("", dataCurrency[index]["volume"]),
                    _column("", dataCurrency[index]["rate"]),
                    _column("", dataCurrency[index]["total"]),
                  ],
                ),
              ),
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dataCurrency.length + 1,
          shrinkWrap: true,
          ),
      );
    }
    else{
      return new Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(width: 3.0, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0,),
            )
          ),
          child: Text("This currency not found on this rate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        )
      );
    }
  }
}

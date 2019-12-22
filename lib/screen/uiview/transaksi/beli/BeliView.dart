import 'package:flutter/material.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliConfirmView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliFormView.dart';
import 'package:teepme/theme/MainAppTheme.dart';


class BeliView extends StatefulWidget {
  final AnimationController animationController;
  const BeliView({Key key, this.animationController}) : super(key: key);
  
  @override
  _BeliViewState createState() => new _BeliViewState();
}

class _BeliViewState extends State<BeliView> {
  var scrollController = ScrollController();
  List<Widget> listViews = List<Widget>();
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  
  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      } 
    });
    super.initState();
  }

  void addAllListData() {
    var count = 1;
    listViews.add(
      BeliFormView(
        mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MainAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.blueGrey, //change your color here
            ),
            title: Text("Beli", style: TextStyle(color: Colors.blueGrey)),
            centerTitle: true,
          ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            _typeStep(),
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.only(),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }
  
  int currentStep = 0;
  List<Step> spr = <Step>[];
  List<Step> _getSteps() {
    spr = <Step>[
      Step(
        state: _getState(1),
        title: Text("Pick"),
        content: new Wrap(
              children:<Widget>[
                BeliFormView(
                  mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / 0) * 5, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController,
                ),
              ]
            ),
        isActive: (currentStep == 0 ? true : false)
      ),
      Step(
        title: Text("Confirm"),
        content: new Wrap(
              children:<Widget>[
                BeliConfirmView(
                  mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / 0) * 5, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController,
                ),
              ]
            ),
        isActive: (currentStep == 1 ? true : false),
        state: _getState(2),
      ),
      Step(
        title: Text("Payment"),
        content: Text("Konfirmasi Step"),
        isActive: (currentStep == 2 ? true : false),
        state: _getState(3),
      )
    ];
    return spr;
  }
    
  Widget _typeStep() => Container(
    child: Stepper(
      
      controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () {
              setState(() {
                currentStep < spr.length - 1 ? currentStep += 1 : currentStep = 0;
              });
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Next'),
          ),
        );
      },
      
      steps: _getSteps(),
      currentStep: currentStep,
      type: StepperType.horizontal,
      onStepTapped: (step) {
        setState(() {
          currentStep = step;
          print(step);
        });
      },
      onStepCancel: () {
        setState(() {
          currentStep > 0 ? currentStep -= 1 : currentStep = 0;
        });
      },
      onStepContinue: () {
        setState(() {
          currentStep < spr.length - 1 ? currentStep += 1 : currentStep = 0;
        });
      },
    ),
  );
  
  StepState _getState(int i) {
    if (currentStep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }

  
}
import 'package:flutter/material.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliConfirmView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliFormView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

import 'BeliViewState-test-inherit.dart';
import 'TransactionBeliModel-test-inherit.dart';

class BeliViewTestInherit extends StatefulWidget {
  final AnimationController animationController;
  const BeliViewTestInherit({Key key, this.animationController}) : super(key: key);
  
  @override
  BeliViewStateTestInherit createState() => new BeliViewStateTestInherit();

}

class BeliViewStateTestInherit extends State<BeliViewTestInherit> {
  var scrollController = ScrollController();
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  int currentStep = 0;
  List<Step> spr;
  
  TransactionBeliModelTestInherit transactionBeliModel;
  
  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    
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

    spr = <Step>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainerTestInherit.of(context);
    transactionBeliModel = container.model;
    
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
            _typeStep(context),
          ],
        ),
      ),
    );
  }

  List<Step> _getSteps(BuildContext context) {
    final container = StateContainerTestInherit.of(context);
    transactionBeliModel = container.model;
    
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
                  //func: function(),
                ),
                /*
                new StateContainer(child: new BeliFormView1(
                  mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / 0) * 5, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController, func: function()
                ),)
                */
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
                  //func: function(),
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
    
  Widget _typeStep(BuildContext context) {
    final container = StateContainerTestInherit.of(context);
    return Container(
    
    child: Stepper(
      steps: _getSteps(context),
      currentStep: currentStep,
      type: StepperType.horizontal,
      
      controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container()
          /*
          RaisedButton(
            onPressed: () {
              continueStep();
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Next'),
          ),
          */
        );
      },
      
      onStepTapped: (step) {
        if (step <= currentStep){
          setState(() {
            currentStep = step;
            container.updateModel(currentStep: step);
          });
        }
      },
      /*
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
      */
    ),
  );
  }
  
  void continueStep(){
    setState(() {
      currentStep < spr.length - 1 ? currentStep += 1 : currentStep = 0;
    });
  }

  function() => setState(() {
    final container = StateContainerTestInherit.of(context);
    transactionBeliModel = container.model;
    currentStep = transactionBeliModel == null ? currentStep : transactionBeliModel.currentStep;
    //currentStep < spr.length - 1 ? currentStep += 1 : currentStep = 0;
    
  });


  StepState _getState(int i) {
    if (currentStep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }
}
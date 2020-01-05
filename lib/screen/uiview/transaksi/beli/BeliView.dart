import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teepme/bloc/Transaksi/BeliBloc.dart';
import 'package:teepme/bloc/Transaksi/LocationBloc.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliConfirmView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliFormView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliPaymentView.dart';
import 'package:teepme/theme/MainAppTheme.dart';



class BeliView extends StatefulWidget {
  final AnimationController animationController;
  final BeliBloc bloc;
  final LocationBloc blocLocation;
  const BeliView({Key key, this.animationController, this.bloc, this.blocLocation}) : super(key: key);
  
  @override
  BeliViewState createState() => new BeliViewState();

}

class BeliViewState extends State<BeliView> {
  var scrollController = ScrollController();
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  int currentStep = 0;
  List<Step> spr;
  
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
        backgroundColor: Colors.white,
        body: _typeStep(),
      ),
    );
  }
 
  List<Step> _getSteps(BuildContext context) {
    spr = <Step>[
      Step(
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
                  bloc: widget.bloc,
                ),
                
              ]
            ),
        state: ((widget.bloc.currentState.currentStep == null ? 0 : widget.bloc.currentState.currentStep) >= 1) ? StepState.complete : StepState.indexed,
        isActive: ((widget.bloc.currentState.currentStep == null ? 0 : widget.bloc.currentState.currentStep) == 0) ? true : false
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
                  bloc: widget.bloc,
                  blocLocation: widget.blocLocation,
                ),
              ]
            ),
        state: ((widget.bloc.currentState.currentStep == null ? 0 : widget.bloc.currentState.currentStep) >= 2) ? StepState.complete : StepState.indexed,
        isActive: ((widget.bloc.currentState.currentStep == null ? 0 : widget.bloc.currentState.currentStep) == 1) ? true : false
      ),
      Step(
        title: Text("Payment"),
        content: new Wrap(
          children:<Widget>[
            BeliPaymenView(
              mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / 0) * 5, 1.0,
                          curve: Curves.fastOutSlowIn))),
              mainScreenAnimationController: widget.animationController,
            ),
          ]
        ),
        state: ((widget.bloc.currentState.currentStep == null ? 0 : widget.bloc.currentState.currentStep) >= 3) ? StepState.complete : StepState.indexed,
        isActive: ((widget.bloc.currentState.currentStep == null ? 0 : widget.bloc.currentState.currentStep) == 2) ? true : false
      )
    ];
    return spr;
  }
    
  Widget _typeStep() =>
    BlocBuilder(
    bloc: BlocProvider.of<BeliBloc>(context),
    builder: (context, TransactionBeliState state) {
      return Container(
        child: Theme(
          data: ThemeData(canvasColor: Colors.white),
          child: Stepper(
          steps: _getSteps(context),
          currentStep: widget.bloc.currentState.currentStep,
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
            if (step <= widget.bloc.currentState.currentStep){
              widget.bloc.onBack();
            }else{
              widget.bloc.onContinue();
            }
          },
          
        ),
        )
      );
    }
  );  
}
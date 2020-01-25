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

class BeliViewState extends State<BeliView> 
  with TickerProviderStateMixin {
  int currentStep = 0;
  List<Step> spr;
  AnimationController animationController;

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
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
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
    );
    
  }
 
  Widget _typeStep() {
    final bloc = BlocProvider.of<BeliBloc>(context); 
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.data == null){
          return Container();
        }else{ 
          return BlocBuilder(
            bloc: bloc,
            builder: (context, TransactionBeliState state) {
              return Container(
                child: Theme(
                  data: ThemeData(canvasColor: Colors.white),
                  child: Stepper(
                  //steps: _getSteps(context),
                  steps: <Step>[
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
                              ),
                              
                            ]
                          ),
                      state: ((state.currentStep == null ? 0 : state.currentStep) >= 1) ? StepState.complete : StepState.indexed,
                      isActive: ((state.currentStep == null ? 0 : state.currentStep) == 0) ? true : false
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
                      state: ((state.currentStep == null ? 0 : state.currentStep) >= 2) ? StepState.complete : StepState.indexed,
                      isActive: ((state.currentStep == null ? 0 : state.currentStep) == 1) ? true : false
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
                      state: ((state.currentStep == null ? 0 : state.currentStep) >= 3) ? StepState.complete : StepState.indexed,
                      isActive: ((state.currentStep == null ? 0 : state.currentStep) == 2) ? true : false
                    )
                  ],
                  currentStep: state.currentStep,
                  type: StepperType.horizontal,
                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container()
                    );
                  },
                  onStepTapped: (step) {
                    if (step <= state.currentStep){
                      bloc.onBack();
                    }else{
                      bloc.onContinue();
                    }
                  },
                  
                ),
                )
              );
            }
          );  
        }
      }
    );
        
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
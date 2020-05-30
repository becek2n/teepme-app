import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/bloc/Transaksi/BuyBloc.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliConfirmView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliFormView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliPaymentView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliProcessPaymentView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/BeliProcessView.dart';
import 'package:teepme/screen/uiview/transaksi/beli/RateList.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class BuyView extends StatefulWidget {
  final AnimationController animationController;
  const BuyView({Key key, this.animationController}) : super(key: key);
  
  @override
  BuyViewState createState() => new BuyViewState();

}

class BuyViewState extends State<BuyView> 
  with TickerProviderStateMixin {
  int currentStep = 0;
  List<Step> spr;
  AnimationController animationController;
  SharedPreferences preferences;
  String userName;
  
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    getDataCart();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  
  void getDataCart() async{
    final bloc = BlocProvider.of<BuyBloc>(context);
    preferences = await SharedPreferences.getInstance();
    var username = preferences.getString("userName");
      userName = username;
      bloc.onGetDataCart(username);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BuyBloc>(context);
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, BuyState state) { 
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
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Beli", style: TextStyle(color: Colors.black)),
                          SizedBox(
                            height: 38,
                            width: 38,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                              onTap: () {},
                              child: Center(
                                child: Badge(
                                  badgeContent: Text((state.cartList == null) ? "0" : state.cartList.length.toString()),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: MainAppTheme.grey,
                                  ),
                                ) 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) 
                  ),
                backgroundColor: Colors.white,
                body: _typeStep(),
              ),
            );
          }
        );
      }
    ); 
        
    
  }
 
  Widget _typeStep() {
    final bloc = BlocProvider.of<BuyBloc>(context); 
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.data == null){
          return Container();
        }else{ 
          return BlocBuilder(
            bloc: bloc,
            builder: (context, BuyState state) {
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
                          RateList(),
                          
                        ]
                      ),
                      state: ((state.currentStep == null ? 0 : state.currentStep) >= 1) ? StepState.complete : StepState.indexed,
                      isActive: ((state.currentStep == null ? 0 : state.currentStep) == 0) ? true : false
                    ),
                    Step(
                      title: Text("Confirm"),
                      content: new Wrap(
                            children:<Widget>[
                              BeliProcessView(
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
                          BeliProcessPaymentView(
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
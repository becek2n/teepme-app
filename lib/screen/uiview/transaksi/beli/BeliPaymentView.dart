import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:teepme/bloc/Transaksi/BeliBloc.dart';
import 'package:teepme/bloc/Master/PaymentBloc.dart';
import 'package:teepme/theme/MainAppTheme.dart';
import 'package:teepme/main.dart';

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
  final formatCurrency = NumberFormat('#,##0', 'en_US');

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    final bloc = BlocProvider.of<PaymentBloc>(context); 
    bloc.onGetData();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PaymentBloc>(context); 
    final _width = MediaQuery.of(context).size.width;
    ProgressDialog pr = new ProgressDialog(context);
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          Future.delayed(Duration.zero, () => pr.show());
          return Container();
        }
        else{
          Future.delayed(Duration(milliseconds: 2), () => pr.hide());
          return BlocBuilder(
            bloc: bloc,
            builder: (context, PaymentState state) {
              if (state.paymentList == null){
                return Container();
              }
              else{
                return AnimatedBuilder(
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
                                          (state.isPaymentSelected == false || state.isPaymentSelected == null) ? _listData(state) : formProcessPayment(),
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
            }
          );
        }
      }
    );
  }

  Widget _listData (PaymentState state){
    final bloc = BlocProvider.of<PaymentBloc>(context); 
    return Center(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return  Container(
            child: Card( 
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 5.0, right: 5.0),
                child: ListTile(
                  leading: SizedBox(
                      child: Image.network("http://192.168.43.176:3001/" + state.paymentList[index].image, width: 80.0, alignment: Alignment.centerLeft,)
                    ),
                  title: Text(state.paymentList[index].desc, style: TextStyle(color: Colors.blueGrey)),
                  //subtitle: Text(_payment[index]["text"]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    bloc.onPaymentSelected(state.paymentList[index], true);
                  },
                  selected: true,
                )
              ),
            ),
          );
        },
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.paymentList.length,
      shrinkWrap: true,
      )
    );
  }
            

  //Widget formProcessPayment(PaymentModel model) {
  Widget formProcessPayment() {
    final bloc = BlocProvider.of<BeliBloc>(context); 
    final blocPay = BlocProvider.of<PaymentBloc>(context); 
    ProgressDialog pr = new ProgressDialog(context);
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          Future.delayed(Duration.zero, () => pr.show());
          return Container();
        }
        else{
          Future.delayed(Duration(milliseconds: 2)).then((onvalue) { pr.hide(); });
          return BlocBuilder(
            bloc: bloc,
            builder: (context, TransactionBeliState state) {
              if (state.transaction == null){
                return Container();
              }
              else{
                return Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      MainAppTheme.white,
                      HexColor("#FFFFFF")
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 5.0, right: 5.0),
                              child: Text("Payment Method", style: TextStyle(fontSize: 14, color: Colors.grey)),
                            )
                          ]
                        ),
                        new Center(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return  Container(
                                child: Card( 
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 5.0, right: 5.0),
                                    child: ListTile(
                                      leading: SizedBox(
                                        child: Image.network("http://192.168.43.176:3001/" + blocPay.currentState.payment.image, width: 80.0, alignment: Alignment.centerLeft,)
                                        ),
                                      //title: Text( "PAYMENT", style: TextStyle(color: Colors.blueGrey)),
                                      subtitle: Text(blocPay.currentState.payment.desc),
                                      onTap: () {
                                        blocPay.onPaymentSelected(null, false);
                                      },
                                      selected: true,
                                    )
                                  ),
                                ),
                              );
                            },
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          shrinkWrap: true,
                          )
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: 5.0, right: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Rate Total", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(formatCurrency.format(double.parse(bloc.currentState.transaction.map<double>((m) => m.rate).reduce((a,b )=>a+b).toString())), style: TextStyle(fontSize: 16)),
                                ],
                              ) 
                            )
                          ]
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10.0),
                            child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: 5.0, right: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Amount", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(formatCurrency.format(double.parse(bloc.currentState.transaction.map<double>((m) => m.amountTotal).reduce((a,b )=>a+b).toString())), style: TextStyle(fontSize: 16)),
                                ],
                              ) 
                            )
                          ]
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10.0),
                            child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 0.0, top: 0.0, left: 5.0, right: 5.0),
                          child: Column(
                            children: <Widget>[
                              new TextFormField(
                                decoration: const InputDecoration(labelText: "Email (optional)"),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                        new Row(
                          children: <Widget>[
                            Expanded( // Constrains AutoSizeText to the width of the Row
                              child: Padding(
                              padding: const EdgeInsets.only(bottom: 0.0, top: 10.0, left: 5.0, right: 5.0),
                              child: AutoSizeText("We will send you the payment code along with payment instructions to your email.", maxLines:2),
                            )
                            )
                          ]
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SizedBox(
                            width: 300.0, // match_parent
                            child: new RaisedButton(
                              onPressed: (){},
                              color: Colors.greenAccent,
                              textColor: Colors.white,
                              child: new Text('Process'),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          );
        }
      },
    );
  }
}

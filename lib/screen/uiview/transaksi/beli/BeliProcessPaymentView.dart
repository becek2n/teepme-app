import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/bloc/Master/CurrencyBloc.dart';
import 'package:teepme/bloc/Transaksi/BuyBloc.dart';
import 'package:teepme/bloc/Master/PaymentBloc.dart';
import 'package:teepme/bloc/Transaksi/LocationBloc.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/screen/uiview/widget_collection/PopupAlert.dart';
import 'package:teepme/theme/MainAppTheme.dart';
import 'package:teepme/main.dart';
import 'package:teepme/globals.dart' as globals;


class BeliProcessPaymentView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;
  
  const BeliProcessPaymentView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _BeliProcessPaymentViewState createState() => _BeliProcessPaymentViewState();
}

class _BeliProcessPaymentViewState extends State<BeliProcessPaymentView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final formatCurrency = NumberFormat('#,##0', 'en_US');
  SharedPreferences preferences;
  int idUser;
  ProgressDialog pr;

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  
  getSharePref() async{
    preferences = await SharedPreferences.getInstance();
    var data = preferences.getInt("idUser");
    setState(() {
      idUser = data;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    final bloc = BlocProvider.of<PaymentBloc>(context); 
    bloc.onGetData();
    getSharePref();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    final bloc = BlocProvider.of<PaymentBloc>(context); 
    final _width = MediaQuery.of(context).size.width;
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          Future.delayed(Duration.zero, ()=> pr.show());
          return Container();
          //return Center(child: CupertinoActivityIndicator(),);
        }
        else{
          return BlocBuilder(
            bloc: bloc,
            builder: (context, PaymentState state) {
              if (state.paymentList == null){
                return Container();
              }
              else{
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
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
                      child: Image.network(globals.urlAPI + state.paymentList[index].image, width: 80.0, alignment: Alignment.centerLeft,)
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
    pr = new ProgressDialog(context, isDismissible: false);
    final bloc = BlocProvider.of<BuyBloc>(context); 
    final blocPay = BlocProvider.of<PaymentBloc>(context); 
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          Future.delayed(Duration.zero, ()=> pr.show());
          return Container();
          //return Center(child: CupertinoActivityIndicator(),);
        }
        else{
          return BlocBuilder(
            bloc: bloc,
            builder: (context, BuyState state) {
              if (state.cartList == null){
                return Container();
              }
              else{
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
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
                                        child: Image.network(globals.urlAPI + blocPay.currentState.payment.image, width: 80.0, alignment: Alignment.centerLeft,)
                                        ),
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
                                  Text("Volume", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(formatCurrency.format(double.parse(state.cartList.map<int>((m) => m.volume).reduce((a,b )=>a+b).toString())), style: TextStyle(fontSize: 16)),
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
                                  Text(formatCurrency.format(getSumAmount(state.cartList)), style: TextStyle(fontSize: 16)),
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
                              onPressed: (){
                                insertData();
                              },
                              color: Colors.blue,
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
  
  void insertData() {
    final blocBeli = BlocProvider.of<BuyBloc>(context); 
    final blocLocation = BlocProvider.of<LocationBloc>(context); 
    final blocPayment = BlocProvider.of<PaymentBloc>(context); 
    var _errMsg = "Oops sorry, something bad happend, please try again!";

    if (blocBeli.currentState.rateList == null){
      Alert(context: context, title: "Alert", desc: "Data transaction is null!").show();
    }else if(blocLocation.currentState.location == null){
        Alert(context: context, title: "Alert", desc: "Location is not selected!").show();
    }else if(blocPayment.currentState.payment == null){
        Alert(context: context, title: "Alert", desc: "Payment method is not selected!").show();
    }else{
      try{
        PopupAlert().alertDialogCuprtino(context, "Please wait...");
        final transactionCode = "xx2";
        final currencyCode = "USD";
        final paymentCode = blocPayment.currentState.payment.paymentCode;
        final locationCode = blocLocation.currentState.location.locationCode;
        final pickupCode = "P01";
        final amountTotal = double.parse(blocBeli.currentState.cartList.map<double>((m) => m.rate).reduce((a,b )=>a+b).toString()); //blocBeli.currentState.rate;
        final volumeTotal = getSumAmount(blocBeli.currentState.cartList);//blocBeli.currentState.volume;
        TransactionModel transactionModel = TransactionModel(
          transactionCode: transactionCode, 
          currencyCode: currencyCode,
          paymentCode: paymentCode,
          locationCode: locationCode,
          pickupCode: pickupCode,
          userName: idUser.toString(),
          amountTotal: amountTotal,
          volumeTotal: volumeTotal);
        
        List<TransactionDetailModel> transactionDetailModel =  [];
        for(int i= 0; i < blocBeli.currentState.cartList.length; i++){
          final uidWallet = blocBeli.currentState.cartList[i].uidWallet;
          final rate = blocBeli.currentState.cartList[i].rate;
          final volume = blocBeli.currentState.cartList[i].volume.toDouble();
          transactionDetailModel.add(TransactionDetailModel(uidWallet: uidWallet, rate: rate, amount: volume ));
        }

        blocBeli.onInsert("BY", transactionModel, transactionDetailModel)
        .then((result) {
          if (result.uid != null){
          Navigator.of(context, rootNavigator: true).pop();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new WillPopScope(
                    onWillPop: () async => false,
                    child: new CupertinoAlertDialog(
                    title: new Text("Congratulation, your transaction success, we sent billing to your email", style: TextStyle(fontSize: 12), ),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                              new MyHomePage(title: '') 
                            )
                          );
                        },
                        child: new Text("Ok"),
                      )
                    ],
                  ),
                );
              }
            );
          }else{
            Navigator.of(context, rootNavigator: true).pop();
            PopupAlert().alertDialogCuprtinoMsg(context, _errMsg);  
          }
        }).catchError((onError) {
          Navigator.of(context, rootNavigator: true).pop();
          PopupAlert().alertDialogCuprtinoMsg(context, _errMsg);
        });
      }catch(SocketException){
        Navigator.of(context, rootNavigator: true).pop();
        PopupAlert().alertDialogCuprtinoMsg(context, _errMsg);
      }
    }
  }

  double getSumAmount(List<TransactionTempModel> model){
    double _amount = 0;
    for(var i = 0; i < model.length; i++){
      _amount += model[i].volume * model[i].rate;
    }
    return _amount;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/bloc/Master/CurrencyBloc.dart';
import 'package:teepme/bloc/Transaksi/BuyBloc.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/models/WalletModel.dart';

class RateList extends StatefulWidget {
 const RateList({Key key}) : super(key: key);
  
  @override
  _RateListState createState() => new _RateListState();
}

class _RateListState extends State<RateList>{
  ProgressDialog pr;
  FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);

  List<WalletModel> modelList = List<WalletModel>();
  SharedPreferences preferences;
  String userName;
  String currencyCode = "USD";
  //double paymentTotal;
  int volumeAmount = 0;
  final rateController = TextEditingController(),
    volumeController = TextEditingController(text: "0"),
    paymentTotalController = TextEditingController(text: "0");

  @override
  void initState() {
    getUserID();
    getDataRate("0");
    final blocCurrency = BlocProvider.of<CurrencyBloc>(context); 
    blocCurrency.onGetData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserID() async{
    preferences = await SharedPreferences.getInstance();
    var username = preferences.getString("userName");
    setState(() {
      userName = username;
    });
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void getDataRate(String value){
    final bloc = BlocProvider.of<BuyBloc>(context);
    bloc.onRateSearch(currencyCode, value);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BuyBloc>(context); 
    final blocCurrency = BlocProvider.of<CurrencyBloc>(context); 
    pr = new ProgressDialog(context, isDismissible: false);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Container();
        }
        else{
          return BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, BuyState state) { 
              if(state.rateList == null){
                Future.delayed(Duration.zero, ()=> pr.show());
                return Container();
              }else{
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
                return Container(
                    color: Colors.white,
                    height: _height,
                    width: _width,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: SingleChildScrollView(
                        child: 
                        Column(
                          children: [
                            Row(
                              children: [
                                BlocBuilder(
                                  bloc: blocCurrency,
                                  builder: (BuildContext context, CurrencyState state) {
                                    if(state.list == null){
                                      return Container();
                                    }else{
                                      return Container(
                                        width: _width * 0.20,
                                        height: 40,
                                        child:  new DropdownButtonFormField<String>(
                                          value: (state.currencyModel == null ) ? currencyCode : state.currencyModel.currencyCode,
                                          items: state.list
                                            .map((label) => DropdownMenuItem(
                                            child: Text(label.currencyCode.toString()),
                                            value: label.currencyCode,
                                          )).toList(),
                                          hint: Text(''),
                                          onChanged: (value) {
                                            var modelSelected = state.list.where((x) => x.currencyCode == value).single;
                                            blocCurrency.onSelected(modelSelected);
                                            setState(() {
                                              currencyCode = value;
                                            });
                                          },
                                        ),
                                      );

                                    }
                                  }
                                ),
                                
                                Container(
                                  width: _width * 0.65,
                                  height: 40,
                                  child: TextField(
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                    textInputAction: TextInputAction.go,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                        child: Icon(Icons.search),
                                        onTap: (){
                                          getDataRate(rateController.text.toString().trim());
                                        },
                                      ),
                                      hintText: "Cari rate...",
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                    controller: rateController,
                                    onSubmitted: (value){
                                      getDataRate(value);
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Card(
                              elevation: 3.0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: ListView.builder(
                                  itemCount: state.rateList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index){
                                    return ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          color: Colors.redAccent
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(state.rateList[index].currencyCode.toString(), style: TextStyle(color: Colors.white),),
                                          ],
                                        ) 
                                      ), 
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(fmf.copyWith(amount: state.rateList[index].rate, symbol: "Rp.", symbolAndNumberSeparator: ' ').output.symbolOnLeft.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Volume " + state.rateList[index].amount.toString(), style: TextStyle(fontSize: 12, color: Colors.grey),),
                                              ],
                                            ) 
                                          ),
                                           Divider(thickness: 2,)
                                        ],
                                      ),
                                      trailing: SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: RaisedButton(
                                          onPressed: (){
                                            _openShopCart(state.rateList[index]);
                                          },
                                          color: Colors.lightGreen,
                                          textColor: Colors.white,
                                          child: new Text('Book', style: TextStyle(fontSize: 10),),
                                        )
                                      ), 
                                    );
                                  },
                                ),
                              ) 
                            )
                          ],
                        ) 
                      )
                  ),
                );
              }
            }
          );
        }
      }
    );
  }

  void _openShopCart(WalletModel walletModel) {
    final bloc = BlocProvider.of<BuyBloc>(context); 
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 240.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add to cart',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      clearAmount();
                    },
                    child: Icon(Icons.close),
                  )    
                ],
              ),
              Divider(thickness: 0.4, color: Colors.black,),
              SizedBox(
                height: 2.0,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.redAccent
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(walletModel.currencyCode.toString(), style: TextStyle(color: Colors.white),),
                    ],
                  ) 
                ), 
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fmf.copyWith(amount: walletModel.rate, symbol: "Rp.", symbolAndNumberSeparator: ' ').output.symbolOnLeft.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[600]),),
                    Divider(thickness: 2,),
                  ],
                ),
                trailing: Container(
                  height: 30,
                  width: 120,
                  child: Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        child: new FloatingActionButton(
                          onPressed: (){
                            if(volumeAmount <= walletModel.amountAvail){
                              if(volumeAmount > 0){
                                volumeAmount = int.parse(volumeController.text.replaceAll(".0", "")) - 1;
                                volumeController.text = volumeAmount.toString();
                                paymentTotalController.text = fmf.copyWith(amount: (volumeAmount * walletModel.rate), symbol: "Rp.", symbolAndNumberSeparator: ' ').output.symbolOnLeft.toString();
                              }
                            }
                          },
                          child:new Icon(
                            const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                            color: Colors.black),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 60,
                        child: TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x4437474F),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          controller: volumeController,
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 25,
                        child: new FloatingActionButton(
                          onPressed: (){
                            if(volumeAmount <= walletModel.amountAvail){
                              if(volumeAmount >=0){
                                volumeAmount = int.parse(volumeController.text.replaceAll(".0", "")) + 1;
                                volumeController.text = volumeAmount.toString();
                                paymentTotalController.text = fmf.copyWith(amount: (volumeAmount * walletModel.rate), symbol: "Rp.", symbolAndNumberSeparator: ' ').output.symbolOnLeft.toString();
                              }
                            }
                          },
                          child: new Icon(Icons.add, color: Colors.black,),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Total Payment ", style: TextStyle( fontSize: 13),),
                    TextField(
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      controller: paymentTotalController,
                      textAlign: TextAlign.center,
                    )
                  ]
                ) 
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    child: RaisedButton(
                      onPressed: (){
                        if(volumeAmount == 0){
                          Alert(context: context, title: "Alert", desc: "Please input volume!").show();
                        }else{
                          TransactionTempModel cartModel = TransactionTempModel(userID: userName, uidWallet: walletModel.uid, currencyCode: walletModel.currencyCode, volume: volumeAmount, rate: walletModel.rate);
                          bloc.onAddToCart(cartModel).then((value) {
                            if(value){
                              bloc.onGetDataCart(userName);
                            }
                          });
                          clearAmount();
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      child: new Text('Add more', style: TextStyle(fontSize: 10),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Container(
                      height: 30,
                      child: RaisedButton(
                        onPressed: (){
                          if(volumeAmount == 0){
                            Alert(context: context, title: "Alert", desc: "Please input volume!").show();
                          }else{
                            Navigator.pop(context);
                            clearAmount();
                            bloc.onContinue();
                          }
                        },
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        child: new Text('Process to comfirm', style: TextStyle(fontSize: 10),),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  void clearAmount(){
    volumeAmount = 0;
    volumeController.text = volumeAmount.toString();
    paymentTotalController.text = "0";
  }
}

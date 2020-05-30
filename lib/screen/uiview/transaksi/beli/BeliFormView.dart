import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:teepme/bloc/Master/CurrencyBloc.dart';
import 'package:teepme/bloc/Transaksi/BeliBloc.dart';
import 'package:teepme/main.dart';
import 'package:teepme/models/CurrencyModel.dart';
import 'package:teepme/models/TransactionModel.dart';
//import 'package:teepme/screen/uiview/widget_collection/LoadingIndicator.dart';
import 'package:teepme/theme/MainAppTheme.dart';

import 'package:progress_dialog/progress_dialog.dart';

class BeliFormView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;
  const BeliFormView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _BeliFormViewState createState() => _BeliFormViewState();
}

class _BeliFormViewState extends State<BeliFormView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  

  final textControllerRate = TextEditingController(), 
        textControllerVolume = TextEditingController();
  
  String currencyCode;
  CurrencyModel modelCorrency;
  final formatCurrency = NumberFormat('#,##0', 'en_US');
  ProgressDialog pr;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    
    final bloc = BlocProvider.of<CurrencyBloc>(context); 
    bloc.onGetData();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  

  void _searchCurrency() {
    final bloc = BlocProvider.of<BeliBloc>(context); 
    pr = new ProgressDialog(context);
    //if (currencyCode == null){
    //  Alert(context: context, title: "Alert", desc: "Please select currency!").show();
    //}else 
    if (textControllerRate.text.trim() == ""){
      Alert(context: context, title: "Alert", desc: "Please input rate!").show();
    }else if(textControllerVolume.text.trim() == ""){
        Alert(context: context, title: "Alert", desc: "Please input volume!").show();
    }else{
      bloc.onSearchRate(currencyCode, double.parse(textControllerRate.text), double.parse(textControllerVolume.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          //return LoadingCupertinoWithoutScaffold();
          Future.delayed(Duration.zero, () => pr.show());
          return Container();
        }else{
          final bloc = BlocProvider.of<BeliBloc>(context); 
          final blocCurrency = BlocProvider.of<CurrencyBloc>(context); 
          return BlocBuilder(
            bloc: blocCurrency,
            builder: (BuildContext context, CurrencyState state) {
              if (state.list == null){
                //return LoadingCupertinoWithoutScaffold();
                return Container();
              }else{
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
                return AnimatedBuilder(
                  animation: widget.mainScreenAnimationController,
                  builder: (BuildContext context, Widget child) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: <Widget>[
                          bloc.currentState.visibilityFormInput ? formInput() : new Container(),
                          SizedBox(
                            height: 20.0,
                          ),
                          bloc.currentState.visibilityFormResult ? formSearchResult() : new Container(),
                          
                        ],
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

  Widget formInput() {
    pr = new ProgressDialog(context, isDismissible: false);
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          //return LoadingCupertinoWithoutScaffold();
          Future.delayed(Duration.zero, ()=> pr.show());
          return Container();
        }else{
          final bloc = BlocProvider.of<BeliBloc>(context); 
          final blocCurrency = BlocProvider.of<CurrencyBloc>(context); 
          return BlocBuilder(
            bloc: blocCurrency,
            builder: (BuildContext context, CurrencyState state) {
              if(state.list == null){
                //return LoadingCupertinoWithoutScaffold();
                return Container();
              }else{
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
                modelCorrency = modelCorrency ?? state.currencyModel;
                textControllerRate.text = (textControllerRate.text == "0" || textControllerRate.text == "" ) ? bloc.currentState.rate.toString().replaceAll(".0", "") : textControllerRate.text; 
                textControllerVolume.text = (textControllerVolume.text == "0" || textControllerVolume.text == "" ) ? bloc.currentState.volume.toString().replaceAll(".0", "") : textControllerVolume.text;
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
                        topRight: Radius.circular(60.0)),
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
                        new DropdownButtonFormField<String>(
                          decoration:  const InputDecoration(labelText: 'Currency'),
                            value: (state.currencyModel == null ) ? null : state.currencyModel.currencyCode,
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
                        new TextFormField(
                          controller: textControllerRate,
                          decoration: const InputDecoration(labelText: 'Max Rate'),
                          keyboardType: TextInputType.number,
                        ),
                        new TextFormField(
                          controller: textControllerVolume,
                          decoration: const InputDecoration(labelText: 'Volume'),
                          keyboardType: TextInputType.number,
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new RaisedButton(
                          onPressed: _searchCurrency,
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: new Text('Find'),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          );
        }
      }
    );
  }

  Widget formSearchResult() {
    pr = new ProgressDialog(context, isDismissible: false);
    final bloc = BlocProvider.of<BeliBloc>(context); 
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          Future.delayed(Duration.zero, ()=> pr.show());
          //return LoadingCupertinoWithoutScaffold();
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
                    color: MainAppTheme.grey.withOpacity(0.6),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  new SizedBox(
                    height: 10.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Max Rate : " + formatCurrency.format(bloc.currentState.rate), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Volume : " + formatCurrency.format(bloc.currentState.volume), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    ]
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child : new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Available ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  (bloc.currentState.currencyResult == "avail") ? searchCurrencyView(bloc.currentState.transaction, "false") : formSearchResultRateAvailPartial(_currencyPartial, _currencySuggestion),
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.0, color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0,),
                        )
                      ),
                      child: Text(
                        "Total IDR " + formatCurrency.format(double.parse(bloc.currentState.transaction.map<double>((m) => m.amountTotal).reduce((a,b )=>a+b).toString())), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                    )
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            bloc.onCancelSearch();
                          });
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: new Text('Cancel'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (bloc.currentState.transaction == null){
                            Alert(context: context, title: "Alert", desc: "Rate not found!").show();
                          }else{
                            bloc.onContinue();
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: new Text('Book'),
                      ),
                    ]
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
  
  List _currencyPartial = [];
  List _currencySuggestion = [
    {"volume": "500", "rate" : "13.800", "total" : "6.900.000"},
  ];

  _column(String isSuggestion, String value){
   return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Text(formatCurrency.format(value), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Text(formatCurrency.format(double.parse(value)) , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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

  Widget searchCurrencyView(List<RateModel> dataCurrency, String isSuggestion){
    if (dataCurrency.length > 0){
      return new Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 3.0, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(2.0)
            )
          ),
          child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0){
              return Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:new Text("Volume",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child:new Text("Rate",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ]
              );
            }
            index -=1;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    _column("", dataCurrency[index].amountAvail.toString()),
                    _column("", dataCurrency[index].rate.toString()),
                    _column(isSuggestion, (dataCurrency[index].amountAvail * dataCurrency[index].rate).toString() ),
                  ],
                ),
              ),
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dataCurrency.length + 1,
          shrinkWrap: true,
          ),
        ),
      );
    }
    else {
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

  Widget formSearchResultRateAvailPartial(List dataCurrencyAvail, List dataCurrencyPartial) {
    return new  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            searchCurrencyView(dataCurrencyAvail, "true"),
            new SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child : new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Suggestion ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            new SizedBox(
              height: 10.0,
            ),
            searchCurrencyView(dataCurrencyPartial, "true"),
          ],
      ),
    );
  }

  
}

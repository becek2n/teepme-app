import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:teepme/Repositories/CurrencyRepository.dart';
import 'package:teepme/Repositories/TrasansactionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/main.dart';
import 'package:teepme/models/CurrencyModel.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/theme/MainAppTheme.dart';

import 'BeliViewState-test-inherit.dart';
import 'TransactionBeliModel-test-inherit.dart';

class BeliFormView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;
  final Function func; 
  const BeliFormView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.func})
      : super(key: key);
  @override
  _BeliFormViewState createState() => _BeliFormViewState();
}

class _BeliFormViewState extends State<BeliFormView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  

  String _currencyController;
  bool visibilityFormResult = false, 
      visibilityFormInput = true;
  String currencyResult = "";
  List<CurrencyModel> _currencySelect = <CurrencyModel>[];
  List<TransactionModel> _transaction = <TransactionModel>[];
  final textControllerRate = TextEditingController(), 
        textControllerVolume = TextEditingController();
  double sumOfCurrency = 0;
  final formatCurrency = NumberFormat('#,##0', 'en_US');

  TransactionBeliModelTestInherit transactionBeliModel = new TransactionBeliModelTestInherit(0,  "",  0,  0, true,  false, "",  "", null);

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  
  
  void getDataAPIDropdown(){
    //bind data dropdown
    APIWeb().load(CurrencyRepositories.getData).then((currencyData) => {
      setState(() => {
        _currencySelect = currencyData
      })
    });
  }

  void _searchCurrency() {
    if (textControllerRate.text == ""){
        Alert(context: context, title: "Alert", desc: "Please input rate!").show();
    }else if(textControllerVolume.text == ""){
        Alert(context: context, title: "Alert", desc: "Please input volume!").show();
    }else{
        getDataAPIFindRate();
    }
  }

  void getDataAPIFindRate(){
    final container = StateContainerTestInherit.of(context);
    Map<String, dynamic> jsonBody = {
      'amount': textControllerVolume.text,
      'rate': textControllerRate.text,
    };
    APIWeb().post(TransactionRepository.getDataFind(jsonBody)).then((transaction) => {
      setState(() {
        _transaction = transaction;
        sumOfCurrency = double.parse(_transaction.map<double>((m) => m.amountTotal).reduce((a,b )=>a+b).toString());

        container.updateModel(currentStep: 0, currencyResult: "avail", visibilityFormInput : false, visibilityFormResult : true, 
            rate: double.parse(textControllerRate.text), volume: double.parse(textControllerVolume.text), transaction: _transaction);
      })
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    getDataAPIDropdown();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainerTestInherit.of(context);
    if (container.model != null){
      transactionBeliModel = container.model;
    }
    //transactionBeliModel = container.model;
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //visibilityFormInput ? formInput() : new Container(),
                transactionBeliModel.visibilityFormInput ? formInput() : new Container(),
                SizedBox(
                  height: 20.0,
                ),
                //visibilityFormResult ? formSearchResult() : new Container(),
                transactionBeliModel.visibilityFormResult ? formSearchResult() : new Container(),
                
              ],
            ),
        );
      },
    );
  }

  Widget formInput() {
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Container();
        }
        else{
          textControllerRate.text = transactionBeliModel.rate.toString().replaceAll(".0", ""); 
          textControllerVolume.text = transactionBeliModel.volume.toString().replaceAll(".0", ""); 
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
                      value: _currencyController,
                      items: _currencySelect
                        .map((label) => DropdownMenuItem(
                        child: Text(label.currencyCode.toString()),
                        value: label.currencyCode.toString(),
                      )).toList(),
                      hint: Text(''),
                      onChanged: (value) {
                        setState(() {
                          _currencyController = value;
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
  Widget formSearchResult() {
    var container = StateContainerTestInherit.of(context);
    transactionBeliModel = container.model;
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
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
                      Text("Max Rate : " + formatCurrency.format(transactionBeliModel.rate), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Volume : " + formatCurrency.format(transactionBeliModel.volume), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
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
                  (transactionBeliModel.currencyResult == "avail") ? searchCurrencyView(transactionBeliModel.transaction, "false") : formSearchResultRateAvailPartial(_currencyPartial, _currencySuggestion),
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
                        "Total IDR " + formatCurrency.format(sumOfCurrency), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                    )
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            transactionBeliModel.visibilityFormInput = true;
                            transactionBeliModel.visibilityFormResult = false;
                          });
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: new Text('Cancel'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (transactionBeliModel.transaction == null){
                            Alert(context: context, title: "Alert", desc: "Rate not be found!").show();
                          }else{
                            container.updateModel(currentStep: 1);
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

  Widget searchCurrencyView(List<TransactionModel> dataCurrency, String isSuggestion){
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

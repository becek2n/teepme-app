import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/Repositories/TrasansactionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/bloc/Transaksi/TransactionBloc.dart';
import 'package:teepme/globals.dart' as globals;
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/screen/uiview/transaksi/TransactionHistoryDetailView.dart';

class TransactionHistoryPagingView extends StatefulWidget {
  final AnimationController animationController;
  const TransactionHistoryPagingView({Key key, this.animationController}) : super(key: key);
  
  @override
  _TransactionHistoryPagingViewState createState() => new _TransactionHistoryPagingViewState();

}

class _TransactionHistoryPagingViewState extends State<TransactionHistoryPagingView> 
  with TickerProviderStateMixin {
  double topBarOpacity = 0.0;
  var scrollController = ScrollController();
  int currentStep = 0;
  List<Step> spr;
  AnimationController animationController;
  ProgressDialog pr;
  int sharedValue = 0;
  int currentPage = 0, pageSize = 10;
  List<TransactionModel> transactionList = List<TransactionModel>();
  final formatCurrency = NumberFormat('#,##0', 'en_US');

  String userID;

  @override
  void initState() {
    //get data 
    getSharePref();
    //getDataTransaction();
    
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  SharedPreferences preferences;
  getSharePref() async{
    preferences = await SharedPreferences.getInstance();
    var data = preferences.getInt("idUser");
    setState(() {
      userID = data.toString();
      getDataTransaction();
      
    });
  }

  void getDataTransaction(){
    APIWeb().load(TransactionRepository.getByUserId(userID, pageSize, currentPage)).then((val){
      setState(() {
        transactionList.addAll(val);
      });
    });
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        setState(() {
          currentPage += 1;
        });
        print('End Scroll ' + currentPage.toString());
        getDataTransaction();
      }
    }
    return true;
  }

  final Map<int, Widget> textWidgets = const <int, Widget>{
    0: Text('Buy'),
    1: Text('Sell'),
  };

  final Map<int, Widget> widgetsBody = <int, Widget>{
    0: Center(
      child: FlutterLogo(
        colors: Colors.indigo,
        size: 200.0,
      ),
    ),
    1: Center(
      child: FlutterLogo(
        colors: Colors.cyan,
        size: 200.0,
      ),
    ),
  };


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return Container(
          child: Scaffold(
            appBar : new AppBar(
              title: new Text("History"),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  SizedBox(
                    width: 500.0,
                    child: CupertinoSegmentedControl<int>(
                      children: textWidgets,
                      onValueChanged: (int val) {
                        setState(() {
                          sharedValue = val;
                        });
                      },
                      groupValue: sharedValue,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                  ),
                  //Expanded(child: (sharedValue == 0) ? getListBuy() : widgetsBody[sharedValue]),
                  Expanded(child: (sharedValue == 0) ? getDataBuy() : widgetsBody[sharedValue]),
                  SizedBox(height: 60.0,)
                ],
              ),
            ),
          )
        );
      }
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 2));
    return true;
  }

  Widget getDataBuy(){
    return transactionList == null ? Container() : 
     NotificationListener(
      onNotification: onNotification,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: transactionList.length,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return  Card( 
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0, top: 1.0, left: 2.0, right: 2.0),
              child: ListTile(
                leading: SizedBox(
                  child: Image.network(globals.urlAPI + "images/flag-" + transactionList[i].currencyCode.toLowerCase() + ".png", width: 40.0, alignment: Alignment.centerLeft,)
                ),
                title: Text(transactionList[i].transactionCode, style: TextStyle(fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Amount : " + formatCurrency.format(transactionList[i].amountTotal), style: TextStyle(fontSize: 12),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Pickup : " + transactionList[i].locationName, style: TextStyle(fontSize: 12),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Status : " + transactionList[i].status,  style: TextStyle(color: Colors.red, fontSize: 10)),
                    ),
                    
                  ],
                ), 
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("IDR " + formatCurrency.format(transactionList[0].volumeTotal), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ), 
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                      BlocProvider<TransactionBloc>(
                        builder: (BuildContext context) => TransactionBloc(),
                        child: TransactionHistoryDetailView(animationController: animationController, transactionUID: transactionList[i].uid,) 
                      ) 
                    )
                  );
                },
                selected: true,
              )
            ),
          );
        },
      )
    );
  }
}
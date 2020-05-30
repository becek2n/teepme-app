import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:teepme/bloc/Transaksi/TransactionBloc.dart';
import 'package:teepme/globals.dart' as globals;
import 'package:teepme/screen/main/AppMainBar.dart';
import 'package:teepme/screen/uiview/transaksi/TransactionHistoryDetailView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

const Color _colorOne = Color(0x33000000); 
const Color _colorTwo = Color(0x24000000); 
const Color _colorThree = Color(0x1F000000); 

class TransactionHistoryView extends StatefulWidget {
  final AnimationController animationController;
  const TransactionHistoryView({Key key, this.animationController}) : super(key: key);
  
  @override
  _TransactionHistoryViewState createState() => new _TransactionHistoryViewState();

}

class _TransactionHistoryViewState extends State<TransactionHistoryView> 
  with TickerProviderStateMixin {
  double topBarOpacity = 0.0;
  var scrollController = ScrollController();
  int currentStep = 0;
  List<Step> spr;
  AnimationController animationController;
  ProgressDialog pr;
  int sharedValue = 0;
  final formatCurrency = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
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

    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
          color: MainAppTheme.background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                getForm(context),
                AppBarMainScreen(animationController: animationController, topBarOpacity: topBarOpacity,),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget getForm(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: 1,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        animationController.forward();
        return Container(
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 16.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(3.0),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          offset: Offset(0.0, 3.0),
                          blurRadius: 5.0,
                          spreadRadius: -1.0,
                          color: _colorOne,
                        ),
                        BoxShadow(
                          offset: Offset(0.0, 6.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          color: _colorTwo,
                        ),
                        BoxShadow(
                          offset: Offset(0.0, 1.0),
                          blurRadius: 18.0,
                          spreadRadius: 0.0,
                          color: _colorThree,
                        ),
                      ],
                    ),
                    //child: widgetsBody[sharedValue],
                    child: (sharedValue == 0) ? getDataBuy() : widgetsBody[sharedValue],
                  ),
                ),
            ],
          ),
        );
      }
    );
        
  }
  
  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget getDataBuy(){
    pr = new ProgressDialog(context, isDismissible: false);
    final bloc = BlocProvider.of<TransactionBloc>(context); 
    bloc.onGetDataByUserID("user", 10, 1);
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          Future.delayed(Duration.zero, () => pr.show());
          return Container();
        }
        else{
          return BlocBuilder(
            bloc: bloc,
            builder: (context, TransactionState state) {
              if (state is GetTransactionFailure){
                //return Center(child: CupertinoActivityIndicator(),);
                return Container();
              }
              else if (state.transactionList != null){
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
                return ListView.builder(
                  itemBuilder: (context, i) {
                    return  Container(
                      child: Card( 
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0, top: 1.0, left: 2.0, right: 2.0),
                          child: ListTile(
                            leading: SizedBox(
                              child: Image.network(globals.urlAPI + "images/flag-usd.png", width: 40.0, alignment: Alignment.centerLeft,)
                              ),
                            title: Text("IDR Rupiah" + " - " + state.transactionList[i].currencyName, style: TextStyle(fontSize: 16)),
                            subtitle: Text("Rate : " + formatCurrency.format(state.transactionList[i].amountTotal) + " \nPickup : " + state.transactionList[i].locationName),
                            //trailing: Icon(Icons.keyboard_arrow_right),
                            trailing: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("IDR " + formatCurrency.format(state.transactionList[0].volumeTotal), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(state.transactionList[i].status, style: TextStyle(color: Colors.red)),
                                )
                              ],
                            ), 
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                                  BlocProvider<TransactionBloc>(
                                    builder: (BuildContext context) => TransactionBloc(),
                                    child: TransactionHistoryDetailView(animationController: animationController, transactionUID: state.transactionList[i].uid,) 
                                  ) 
                                )
                              );
                            },
                            selected: true,
                          )
                        ),
                      ),
                    );
                  },
                physics: const BouncingScrollPhysics(),
                itemCount: state.transactionList.length,
                shrinkWrap: true,
                );
              }else{
                return Container();
              }
            }
          );
        }
      }
    );
  }
}
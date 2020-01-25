import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:search_widget/search_widget.dart';
import 'package:teepme/bloc/Transaksi/BeliBloc.dart';
import 'package:teepme/bloc/Transaksi/LocationBloc.dart';
import 'package:teepme/main.dart';
import 'package:teepme/models/LocationModel.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/screen/uiview/location/LocationSearch.dart';
import 'package:teepme/theme/MainAppTheme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BeliConfirmView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;
  final TextEditingController textControllerRate, textControllerVolume;
  final List<TransactionModel> transactionList, transactionSuggestionList;
  final LocationBloc blocLocation;

  const BeliConfirmView(
    {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, 
      this.textControllerRate, this.textControllerVolume, this.transactionList, this.transactionSuggestionList, this.blocLocation})
    : super(key: key);
  @override
  _BeliConfirmViewState createState() => _BeliConfirmViewState();
}

class _BeliConfirmViewState extends State<BeliConfirmView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  //String _currencyController;

  bool visibilityFormResult = false;
  String currencyResult = "";
  List<Widget> listViews = List<Widget>();
  TextEditingController editingController = TextEditingController();
  final formatCurrency = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    
    //final blocLocation = BlocProvider.of<LocationBloc>(context); 
    //blocLocation.onGetData();
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

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BeliBloc>(context); 
    final blocLoc = BlocProvider.of<LocationBloc>(context); 
    blocLoc.onGetData();
    
    ProgressDialog pr = new ProgressDialog(context);

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.data == null){
          Future.delayed(Duration.zero, () => pr.show());
          return Container();
        }else{
          Future.delayed(Duration(milliseconds: 2)).then((onvalue) { pr.hide(); });
          return BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, TransactionBeliState state) {
              if (state.transaction == null){
                return Container();
              }else{
                return AnimatedBuilder(
                  animation: widget.mainScreenAnimationController,
                  builder: (BuildContext context, Widget child) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          formConfirm(currencyListConfirm(),
                            BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(60.0))
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          formConfirm(
                            populateLocationSearch(),
                            BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                          formConfirm(
                            Stack(
                              alignment: Alignment.topLeft,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0.0,
                                            right: 16.0,
                                            top: 40.0,
                                          ),
                                        ),
                                        Text("Duration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 8, bottom: 8),
                                        child: Container(
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                        ),
                                      ),
                                    ),
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded( // Constrains AutoSizeText to the width of the Row
                                          child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right:10.0
                                          ),
                                          child: AutoSizeText(
                                              "Normal (Free of Charge)",
                                              maxLines:2,
                                            )
                                          )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right:10.0
                                          ),
                                          child: RaisedButton(
                                            onPressed: () {},
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            child: new Text('Change Duration'),
                                          ),
                                        ),
                                      ]
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Expanded( // Constrains AutoSizeText to the width of the Row
                                          child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right:10.0
                                          ),
                                          child: AutoSizeText(
                                            "You can pick up your purchase at booth on (05-12-2019) (3 days from now).",
                                            maxLines:2,
                                          )
                                          )
                                        ),
                                      ]
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                            BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          formConfirm(
                            Stack(
                              alignment: Alignment.topLeft,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 100,
                                            right: 16,
                                            top: 40,
                                          ),
                                        ),
                                        Text("Total " + formatCurrency.format(double.parse(state.transaction.map<double>((m) => m.amountTotal).reduce((a,b )=>a+b).toString())), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: new Text('Add More Currency'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (blocLoc.currentState.location == null){
                                    Alert(context: context, title: "Alert", desc: "Please select booth location!").show();
                                  }
                                  else{
                                    bloc.onContinue();
                                  }
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: new Text('Payment'),
                              ),
                            ]
                          ),

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
  
  Widget formConfirm(Widget widgetForm, BorderRadius borderRadius) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.data == null){
          return Container();
        }else{
          return Container(
            padding: const EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                MainAppTheme.white,
                HexColor("#FFFFFF")
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: borderRadius,
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
                  widgetForm,
                ],
              ),
            ),
          );
        }
      }
    );
  }
 
  
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

  Widget currencyListConfirm(){
    final bloc = BlocProvider.of<BeliBloc>(context); 
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, TransactionBeliState state) {
        if (state.transaction != null){
          return new Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0){
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child:new Text("Volume",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
                        child:new Text("Rate",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ]
                  );
                }
                index -=1;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        _column("", state.transaction[index].amountAvail.toString()),
                        _column("", state.transaction[index].rate.toString()),
                        _column("", state.transaction[index].amountTotal.toString()),
                      ],
                    ),
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.transaction.length + 1,
              shrinkWrap: true,
            ),
          );

        }
        else{
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
    );
    
  }

  Widget populateLocationSearch(){
    final blocLoc = BlocProvider.of<LocationBloc>(context); 
    return BlocBuilder(
      bloc: blocLoc,
      builder: (BuildContext context, LocationState state) {
        if (state.locationList == null){
          return Container();
        }else{
          return Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 16,
                        ),
                        SearchWidget<LocationModel>(
                          dataList: state.locationList ,
                          hideSearchBoxWhenItemSelected: false,
                          listContainerHeight: MediaQuery.of(context).size.height / 4,
                          queryBuilder: (query, listLocation) {
                            return listLocation
                                .where((item) => item.name
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                          },
                          popupListItemBuilder: (item) {
                            //return PopupListItemWidget(item);
                            return Container(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.only(right: 10.0, left: 10.0),
                                    child: Column(
                                      children: <Widget>[
                                        //new Image.asset(item.image, width: 30.0, alignment: Alignment.centerLeft, ),
                                        Icon(Icons.location_on)
                                      ],
                                    )
                                  ),
                                  new Expanded(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(item.name, style: TextStyle(fontSize: 20)),
                                        new Container(
                                          margin: const EdgeInsets.only(top: 5.0),
                                          child: new Text(item.address),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            );
                          },
                          selectedItemBuilder: (selectedItem, deleteSelectedItem) {
                            //return SelectedItemWidget(selectedItem, deleteSelectedItem);
                            return SizedBox();
                          },
                          // widget customization
                          noItemsFoundWidget: NoItemsFound(),
                          textFieldBuilder: (controller, focusNode) {
                            return MyTextField(controller, focusNode);
                          },
                          onItemSelected: (item) {
                            blocLoc.onLocationSelected(item);
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        selectedLocation()
                        
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      }
    );
  }

  Widget selectedLocation() {
    final blocLoc = BlocProvider.of<LocationBloc>(context); 
    if (blocLoc.currentState.location == null){
      return Text("No selected location");
    }
    else{
      return Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Row(
          children: <Widget>[
            
              new Padding(
              padding: new EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  //new Image.asset(item.image, width: 30.0, alignment: Alignment.centerLeft, ),
                  Icon(Icons.location_on)
                ],
              )
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(blocLoc.currentState.location.name, style: TextStyle(fontSize: 20)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(blocLoc.currentState.location.address),
                  ),
                ],
              ),
            ),  
          ],
        )
      );
    }
  }
}


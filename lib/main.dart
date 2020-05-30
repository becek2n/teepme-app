import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:teepme/bloc/Master/CurrencyBloc.dart';
import 'package:teepme/bloc/Master/PaymentBloc.dart';
import 'package:teepme/bloc/Transaksi/BuyBloc.dart';
import 'package:teepme/bloc/Transaksi/LocationBloc.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/models/MenuTabModel.dart';
import 'package:teepme/screen/main/BottomNavigation.dart';
import 'package:teepme/screen/main/MainMenu.dart';
import 'package:teepme/screen/main/SplashScreen.dart';
import 'package:teepme/screen/uiview/transaksi/TransactionHistoryPagingView.dart';
import 'package:teepme/screen/uiview/user/AccountUserView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

import 'bloc/Transaksi/TransactionBloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  enablePlatformOverrideForDesktop();
  runApp(new MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TeepMe",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      //home: MyHomePage(title: ''),
      //home: LoginView(),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String form ;
  MyHomePage({Key key, this.title, this.form}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
  with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;

  List<MenuTabModel> tabIconsList = MenuTabModel.tabIconsList;

  Widget tabBody = Container(
    color: MainAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });

    animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    
    if (widget.form == "home"){
      tabBody = MainMenu(animationController: animationController);
    }else if (widget.form == "history"){
      tabBody = BlocProvider<TransactionBloc>(
        builder: (BuildContext context) => TransactionBloc(),
        child: TransactionHistoryPagingView() 
      );
      tabIconsList[2].isSelected = true;
    }else{
      tabBody = MainMenu(animationController: animationController);
      tabIconsList[0].isSelected = true;
    }
    
    //tabBody = MainMenu(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    return Container(
      color: MainAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return new BlocProvider<BuyBloc>(
                builder: (BuildContext context) => BuyBloc(),
                child: BlocProvider<CurrencyBloc>(
                  builder: (BuildContext context) => CurrencyBloc(),
                  child: BlocProvider<LocationBloc>(
                    builder: (BuildContext context) => LocationBloc(),
                    child: BlocProvider<PaymentBloc>(
                      builder: (BuildContext context) => PaymentBloc(),
                      child: Stack(
                        children: <Widget>[
                          tabBody,
                          bottomBar(),
                        ],
                      )
                    )
                  )
                )
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: SizedBox(),
        ),
        new BottomNavigation(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (index) {
            if (index == 0) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = MainMenu(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = BlocProvider<TransactionBloc>(
                            builder: (BuildContext context) => TransactionBloc(),
                            child: TransactionHistoryPagingView(animationController: animationController) 
                          );
                });
              });
            } else if (index == 3) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = AccountUser(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }  
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
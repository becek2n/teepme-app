import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/models/MenuTabModel.dart';
import 'package:teepme/screen/main/BottomNavigation.dart';
import 'package:teepme/screen/main/MainMenu.dart';
import 'package:teepme/screen/uiview/user/LoginView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

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
      home: LoginView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
    tabIconsList[0].isSelected = true;
    

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    tabBody = MainMenu(animationController: animationController);
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
    pr = new ProgressDialog(context);
    return FutureBuilder(
      future: testConnection(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          Future.delayed(Duration.zero, () => pr.show());
          return Container();
        } else{
          Future.delayed(Duration(milliseconds: 2)).then((onvalue) {
            pr.hide();
          });
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
                    return Stack(
                      children: <Widget>[
                        tabBody,
                        bottomBar(),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        }
      }
    );
  }

  SharedPreferences preferences;
  Future<bool> testConnection() async{
    bool result;
    preferences = await SharedPreferences.getInstance();
    InternetAddress.lookup("google.com")
      .then((data) {
        result = true;
        preferences.setBool("isConnect", true);
      }).catchError((e) {
        //alertDialogCuprtino(context, "Error", "Connection lost", "OK");
        preferences.setBool("isConnect", false);
    });
    /*
    try{
      await Future.delayed(const Duration(seconds: 2));
      final check = await InternetAddress.lookup("http://172.20.10.10:3001/");
      
      if (check.isNotEmpty)
        result = true;
      preferences = await SharedPreferences.getInstance();
      preferences.setBool("isConnect", true);
    }catch(_){
      //Alert(context: context, title: "Alert", desc: "Connection lost!").show();
      //_showAlert(context);
      _alertDialogCuprtino();
      preferences = await SharedPreferences.getInstance();
      preferences.setBool("isConnect", false);
    }
    */
    return result;
  }

  

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomNavigation(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = MainMenu(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //tabBody = TrainingScreen(animationController: animationController);
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
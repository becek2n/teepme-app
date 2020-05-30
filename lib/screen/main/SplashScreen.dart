import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teepme/bloc/Master/UserBloc.dart';
import 'package:teepme/main.dart';
import 'package:teepme/screen/uiview/user/LoginView.dart';
import 'package:teepme/screen/uiview/widget_collection/PopupAlert.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  final userBloc = UserBloc();

  Future<void> _initializeState() async {
    Future.delayed(
      Duration(milliseconds: 2000),
      (){
        try{
          if(userBloc.currentState is LoggedInState){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                new MyHomePage(title: '',) 
              )
            );
          }else if (userBloc.currentState is LoggedOutState){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                new LoginView() 
              )
            );
          }else if(userBloc.currentState is GetFailure){
            PopupAlert().alertDialogCuprtinoMsg(context, "Internal server error");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                new LoginView() 
              )
            );
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                new LoginView() 
              )
            );
          }
        }catch(e){
            PopupAlert().alertDialogCuprtinoMsg(context, "Internal server error");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                new LoginView() 
              )
            );
        }
      },
    );
  }

  @override
  void initState(){
    super.initState();
    userBloc.onCheckStatusLoggedIn();
    _initializeState();
  }
  @override
  Widget build(BuildContext build){
    return new Scaffold(
      body: Center(
        child: new Image.asset( "lib/assets/images/teepme-logo-transparant.png")
      ),
    );
  }
}
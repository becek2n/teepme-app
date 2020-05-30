import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teepme/bloc/Master/UserBloc.dart';
import 'package:teepme/screen/uiview/user/LoginView.dart';
import 'package:teepme/screen/uiview/widget_collection/PopupAlert.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class SignUpView extends StatefulWidget {
 const SignUpView({Key key}) : super(key: key);
  
  @override
  _SignUpViewState createState() => new _SignUpViewState();

}

class _SignUpViewState extends State<SignUpView> 
  with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  final _ctrTxtName = TextEditingController(), 
        _ctrTxtPhone = TextEditingController(),
        _ctrTxtEmail = TextEditingController(),
        _ctrTxtPassword = TextEditingController(),
        _ctrTxtPasswordConfirm = TextEditingController();

  final userBloc = UserBloc();

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / 2) * 1, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _registreUser(BuildContext context) async {
    var _errMsg = "Oops sorry, something bad happend, please try again!";
    try {
      //validate user
      if(_ctrTxtName.text == null || _ctrTxtName.text == ""){
        PopupAlert().alertDialogCuprtinoMsg(context, "Name must be filled");
      }
      else if(_ctrTxtPhone.text == null || _ctrTxtPhone.text == ""){
        PopupAlert().alertDialogCuprtinoMsg(context, "Phone Number must be filled");
      }
      else if(_ctrTxtEmail.text == null || _ctrTxtEmail.text == ""){
        PopupAlert().alertDialogCuprtinoMsg(context, "Email must be filled");
      }
      else if(_ctrTxtPassword.text == null || _ctrTxtPassword.text == ""){
        PopupAlert().alertDialogCuprtinoMsg(context, "Password must be filled");
      }
      else if(_ctrTxtPasswordConfirm.text == null || _ctrTxtPasswordConfirm.text == ""){
        PopupAlert().alertDialogCuprtinoMsg(context, "Confirm Password must be filled");
      }
      else if(_ctrTxtPassword.text != _ctrTxtPasswordConfirm.text){
        PopupAlert().alertDialogCuprtinoMsg(context, "Confirm Password not match!");
      }else {
        PopupAlert().alertDialogCuprtino(context, "Please wait...");
        userBloc.onRegistreUser(_ctrTxtName.text.trim(),_ctrTxtPhone.text.trim(), _ctrTxtEmail.text.trim(), _ctrTxtPassword.text.trim())
        .then((onValue){
          if (onValue){
            Navigator.of(context, rootNavigator: true).pop();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new WillPopScope(
                    onWillPop: () async => false,
                    child: new CupertinoAlertDialog(
                    title: new Text("Congratulation, your account successfully created", style: TextStyle(fontSize: 12), ),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                              new LoginView() 
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
        });
      }
    } catch (error) {
      PopupAlert().alertDialogCuprtinoMsg(context, _errMsg);
    }
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return BlocBuilder(
      bloc: userBloc,
      builder: (context, UserState state) {
        return AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return Container(
              color: MainAppTheme.background,
              height: _height,
              width: _width,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: new SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0, right: 180.0),
                        child: Text("New Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 45.0, left: 45.0),
                        child: new TextFormField(
                          controller: _ctrTxtName,
                          decoration:  InputDecoration(
                            labelText: 'Name', 
                            icon: Icon(Icons.person),
                          ),
                          style: new TextStyle(color: Colors.deepOrange),
                          keyboardType: TextInputType.text,
                        ),
                      ),  
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 45.0, left: 45.0),
                        child: new TextFormField(
                          controller: _ctrTxtPhone,
                          decoration: const InputDecoration(labelText: 'Phone Number', icon: Icon(Icons.phone)),
                          keyboardType: TextInputType.number,
                          style: new TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 45.0, left: 45.0),
                        child: new TextFormField(
                          controller: _ctrTxtEmail,
                          decoration: const InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 45.0, left: 45.0),
                        child: new TextFormField(
                          controller: _ctrTxtPassword,
                          decoration: const InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: new TextStyle(color: Colors.deepOrange),
                        ),      
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 45.0, left: 45.0),
                        child: new TextFormField(
                          controller: _ctrTxtPasswordConfirm,
                          decoration: const InputDecoration(labelText: 'Confirm Password', icon: Icon(Icons.lock)),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: new TextStyle(color: Colors.deepOrange),
                        ),      
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 300.0, // match_parent
                          child: new RaisedButton(
                            onPressed: (){  
                              _registreUser(context);
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: new Text('Registre'),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0), 
                        child: new RichText(
                          text: new TextSpan(
                            style: new TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              new TextSpan(text: "Have an account? "),
                              new TextSpan(text: 'Sign in here', 
                                style: new TextStyle(fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () => 
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                                      new LoginView() 
                                    )
                                  )
                                ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                )
              ),
            );
          }
        );
      }
    );
  }
}
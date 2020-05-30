import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/bloc/Master/UserBloc.dart';
import 'package:teepme/main.dart';
import 'package:teepme/models/UserModel.dart';
import 'package:teepme/screen/uiview/user/SignUpView.dart';
import 'package:teepme/screen/uiview/widget_collection/PopupAlert.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class LoginView extends StatefulWidget {
 const LoginView({Key key}) : super(key: key);
  
  @override
  _LoginViewState createState() => new _LoginViewState();

}

class _LoginViewState extends State<LoginView> 
  with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  final textControllerUser = TextEditingController(), 
        textControllerPassword = TextEditingController();

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

  Future<void> _submitLogin(BuildContext context) async {
    try {
      PopupAlert().alertDialogCuprtino(context, "Please wait...");
      userBloc.onLogIn(textControllerUser.text.trim(), textControllerPassword.text.trim())
      .then((response) {
        if (response == null){
          Navigator.of(context, rootNavigator: true).pop();
          PopupAlert().alertDialogCuprtinoMsg(context, "Login failed!");
        }else{
          saveSharedLogin(response);
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
              new MyHomePage(title: '') 
            )
          );
        }
      });
    }catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      PopupAlert().alertDialogCuprtinoMsg(context, "Internal server error");
    }
  }
  
  SharedPreferences preferences;
  Future<void> saveSharedLogin(UserModel userModel) async{
    bool result;
    preferences = await SharedPreferences.getInstance();
    preferences.setInt("idUser", userModel.id);
    preferences.setString("userName", userModel.userName);
    preferences.setString("password", userModel.password);
    return result;
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
      return Container(
        color: MainAppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.white,
          body:  new SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                    child: new Container(
                      height: 350.0,
                    child: new Image.asset( "lib/assets/images/transaction-people-2.jpg", height: 350.0, fit: BoxFit.fill,),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  child: new TextFormField(
                    controller: textControllerUser,
                    decoration: const InputDecoration(labelText: 'User / email'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  child: new TextFormField(
                    controller: textControllerPassword,
                    decoration: const InputDecoration(labelText: 'Password'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),      
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 300.0, // match_parent
                    child: new RaisedButton(
                      onPressed: (){  
                        _submitLogin(context);
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: new Text('Login'),
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
                        new TextSpan(text: "You don't have an account? "),
                        new TextSpan(text: 'Sign up here', 
                          style: new TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () => 
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                                new SignUpView() 
                              )
                            )
                        ),
                      ],
                    ),
                  )
                  //Text("You don't have an account? Sign up here")
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 50.0),
                  child: SizedBox(
                    width: 300.0, // match_parent
                  )
                ),
              ],
            ),
          ),
        ),
      );
    }
  );
    
    /*
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Container();
        }
        else{
          return BlocBuilder(
            bloc: userBloc,
            builder: (context, UserState state){
              if(state is LoggedInState){
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                    new MyHomePage(title: '') 
                    )
                  );
                return;
                });
              }else if(state is GetFailure){
                PopupAlert().alertDialogCuprtinoError(context, "Internal server error");
                return Container();
              }else{
                
              }
            }
          );
        }
      }
    );
    */
  }
}
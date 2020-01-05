import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:teepme/main.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class LoginView extends StatefulWidget {
 const LoginView({Key key}) : super(key: key);
  
  @override
  _LoginViewState createState() => new _LoginViewState();

}

class _LoginViewState extends State<LoginView> {
  final textControllerUser = TextEditingController(), 
        textControllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MainAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded (
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                  child: new Container(
                    height: 350.0,
                  child: new Image.asset( "lib/assets/images/transaction-people-2.jpg", height: 350.0, fit: BoxFit.fill,),
                )
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                        new MyHomePage(title: '') 
                      )
                    );
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
              child: Text("Or")
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 50.0),
              child: SizedBox(
                width: 300.0, // match_parent
                child: new RaisedButton(
                  onPressed: (){},
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  child: new Text('Sign Up'),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
 
    
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupAlert {

  void showAlert(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        contentPadding: EdgeInsets.only(top: 10.0),
        title: Text("Connection"),
        content: Container(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,  
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: Text("Your connection is lost, please check connection!"),
            ),
            SizedBox(height: 80.0,),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)
                  ),
                ),
                child: Center(child: Text("OK")),
              ),
            ),
            
          ],
        ),
        ),
      ) 
    );
  }

  void loadingProgress(BuildContext context, String sType, String sContent, String sChildText){
    showDialog(
      context: context,
      child: new CupertinoAlertDialog(
        title: new Text(sType),
        content: new Text(sContent),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: new Text(sChildText),
          )
        ],
      ),
      barrierDismissible: false  
    );
  }

  void alertDialogCuprtino(BuildContext context, String sType){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: new CupertinoAlertDialog(
          title: new Text(sType),
          content: new CupertinoActivityIndicator(radius: 13.0),
        ),
        );
      }
    );
  }

  void alertDialogCuprtinoMsg(BuildContext context, String sMsg){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: new CupertinoAlertDialog(
            title: new Text(sMsg, style: TextStyle(fontSize: 12), ),
            actions: <Widget>[
              new FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: new Text("Ok"),
              )
            ],
          ),
        );
      }
    );
  }
}
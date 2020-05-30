import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingCupertino extends StatelessWidget {
  final String loadingMessage;

  const LoadingCupertino({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
        child: Scaffold(
          body: Center(
            child: CupertinoActivityIndicator()
            )
        )
      );
  }
}

class LoadingCupertinoWithoutScaffold extends StatelessWidget {
  final String loadingMessage;

  const LoadingCupertinoWithoutScaffold({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(50.0),
          ),
          Container(child: Center(child: CupertinoActivityIndicator(),))

        ]
      )
    );
  }
}
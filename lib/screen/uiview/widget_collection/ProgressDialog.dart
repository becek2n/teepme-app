import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

void progressNormal(BuildContext context) {
  pr = new ProgressDialog(context);
  pr.show();
  Future.delayed(Duration(seconds: 2)).then((onvalue) {
    pr.hide();
  });
}

void progressDownload(BuildContext context) {
  double percentage = 0.0;
  pr = new ProgressDialog(context, type: ProgressDialogType.Download);
  pr.style(message: 'Downloading file...');
  
  //Optional
  pr.style(
    message: 'Downloading file...',
    borderRadius: 10.0,
    backgroundColor: Colors.white,
    elevation: 10.0,
    insetAnimCurve: Curves.easeInOut,
    progress: 0.0,
    maxProgress: 100.0,
    progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
  );

  pr.show();

  Future.delayed(Duration(seconds: 2)).then((onvalue) {
    percentage = percentage + 30.0;
    
    pr.update(
      progress: percentage,
      message: "Please wait...",
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    
    Future.delayed(Duration(seconds: 2)).then((value) {
      pr.update(
          progress: percentage, message: "Few more seconds...");
      print(percentage);
      Future.delayed(Duration(seconds: 2)).then((value) {
        percentage = percentage + 30.0;
        pr.update(progress: percentage, message: "Almost done...");

        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide();
          percentage = 0.0;
        });
      });
    });
  });
}
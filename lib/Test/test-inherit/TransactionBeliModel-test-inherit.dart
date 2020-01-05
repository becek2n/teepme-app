
import 'package:teepme/models/TransactionModel.dart';

class TransactionBeliModelTestInherit {
  int currentStep = 0;
  String currencyCode = "";
  double rate = 0;
  double volume = 0;
  bool visibilityFormResult = false, 
      visibilityFormInput = true;
  String currencyController = "";
  String currencyResult = "";
  List<TransactionModel> transaction;

  TransactionBeliModelTestInherit(this.currentStep, this.currencyCode, this.rate, this.volume, this.visibilityFormInput, 
       this.visibilityFormResult, this.currencyController, this.currencyResult, this.transaction);
}

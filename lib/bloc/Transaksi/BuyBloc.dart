import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/TrasansactionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/models/WalletModel.dart';

class BuyBloc extends Bloc<BuyEvent, BuyState> {
  void onContinue() {
    dispatch(ContinueEvent());
  }

  void onBack() {
    dispatch(BackEvent());
  }
  
  void onSearchRate(String currencyCode, double rate, double volume) {
    dispatch(SearchRateEvent(currencyCode: currencyCode, rate: rate, volume: volume));
  }

  void onRateSearch(String currency, String rateValue) {
    dispatch(RateSearchEvent(currency: currency, rateValue: rateValue));
  }

  void onCancelSearch() {
    dispatch(CancelSearchEvent());
  }

  void onGetDataCart(String userID) {
    dispatch(GetDataCart(userID: userID));
  }

  Future<TransactionModel> onInsert(String transactionType, TransactionModel transactionModel, List<TransactionDetailModel> transactionDetailModel) async {
    TransactionModel bResult;
    try {

      dynamic transactionHeader = {
          'transactionCode': transactionModel.transactionCode,
          'currencyCode': transactionModel.currencyCode,
          'paymentCode': transactionModel.paymentCode,
          'locationCode': transactionModel.locationCode,
          'pickupCode': transactionModel.pickupCode,
          'userID': transactionModel.userName.toString(),
          'amountTotal': transactionModel.amountTotal.toString(),
          'volumeTotal': transactionModel.volumeTotal.toString(),
        };
      List<Map<dynamic, dynamic>> transactionDetail = List<Map<dynamic, dynamic>>();
      transactionDetailModel.forEach((detail) {
        Map<dynamic, dynamic> dataDetail = {
          'TransactionUID': detail.uidWallet,
          'UIDWallet': detail.uidWallet,
          'Amount': detail.amount,
          'Rate': detail.rate,
        };
        transactionDetail.add(dataDetail);
      });
      
      Map<dynamic, dynamic> jsonBody = {
        'transactionType': transactionType,
        'transaction': transactionHeader,
        'transactionDetail': transactionDetail
      };
      
      await APIWeb().post(TransactionRepository.insert(jsonBody))
        .then((resp) {
        bResult = resp;
      }).catchError((onError) {
        bResult = null;
      });
    }catch(e){
        bResult = null;
    }
    return bResult;
  }

  Future<bool> onInsertDetail(String transactionCode, String uidWallet, double rate, double volume) async {
    bool bResult = false;
    Map<String, dynamic> jsonBody = {
        'TransactionUID': transactionCode,
        'UIDWallet': uidWallet,
        'Rate': rate.toString(),
        'Amount': volume.toString(),
      };
    await  APIWeb().post(TransactionRepository.insertDetail(jsonBody))
        .then((onValue) {
        bResult = true;
      }).catchError((onError) {
        bResult = false;
      });
      
    return bResult;
  }

  Future<bool> onAddToCart(TransactionTempModel model) async {
    bool bResult = false;
    Map<String, dynamic> jsonBody = {
        'UserID': model.userID,
        'UIDWallet': model.uidWallet,
        'CurrencyCode': model.currencyCode,
        'Volume': model.volume.toString(),
        'Rate': model.rate.toString(),
      };
    await  APIWeb().post(TransactionRepository.postData('transaction/temp/', jsonBody))
        .then((onValue) {
        bResult = true;
      }).catchError((onError) {
        bResult = false;
      });
      
    return bResult;
  }

  @override
  BuyState get initialState => BuyState.initial();

  @override
  Stream<BuyState> mapEventToState(BuyEvent event) async* {
    final _currentState = currentState;
    if (event is ContinueEvent) {
      yield BuyState(currentStep: _currentState.currentStep + 1, rateList: _currentState.rateList, cartList: _currentState.cartList);
    } else if (event is BackEvent) {
      yield BuyState(currentStep: _currentState.currentStep - 1, rateList: _currentState.rateList, cartList: _currentState.cartList);
    } else if (event is RateSearchEvent) {
      Map<String, dynamic> jsonBody = {
        'currency': event.currency.toString().trim(),
        'rateValue': (event.rateValue.toString() == "") ? 0 : event.rateValue.toString().replaceAll(".0", ""),
      };
      final data = await APIWeb().post(TransactionRepository.getDataRateFind(jsonBody));
      yield BuyState(currentStep: _currentState.currentStep, rateList: data, cartList: _currentState.cartList);
    } else if (event is GetDataCart) {
      final data = await APIWeb().load(TransactionRepository.getDataTemp(event.userID));
      
      yield BuyState(currentStep: _currentState.currentStep, rateList: _currentState.rateList, cartList: data);
    }
  }

}


abstract class BuyEvent {}

class ContinueEvent extends BuyEvent {}

class BackEvent extends BuyEvent {}

class DropdownEvent extends BuyEvent {}

class CancelSearchEvent extends BuyEvent {}

class GetDataCart extends BuyEvent {
  final String userID;

  GetDataCart({this.userID});
}

class CurrencyChangeEvent extends BuyEvent {
  final String currencyCode;

  CurrencyChangeEvent({this.currencyCode});
}

class SearchRateEvent extends BuyEvent  {
  final String currencyCode;
  final double rate;
  final double volume;

  SearchRateEvent({this.currencyCode, this.rate, this.volume});
}


class RateSearchEvent extends BuyEvent  {
  final String currency;
  final String rateValue;

  RateSearchEvent({this.currency, this.rateValue});
}

class InsertEvent extends BuyEvent{
  final String transactionCode;
  final String currencyCode;
  final String paymentCode;
  final String locationCode;
  final String pickupCode;
  final String userName;
  final double rateTotal;
  final double volmeTotal;

  InsertEvent({this.transactionCode, this.currencyCode, this.paymentCode, this.locationCode, this.pickupCode, this.userName, this.rateTotal, this.volmeTotal});
}

class BookRateEvent extends BuyEvent {}

class BuyState {
  final int currentStep;
  final List<WalletModel> rateList;
  final List<TransactionTempModel> cartList;
  
  const BuyState({this.currentStep = 0, this.rateList, this.cartList});

  factory BuyState.initial() => BuyState(currentStep: 0);
}

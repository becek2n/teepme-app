import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/TrasansactionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/TransactionModel.dart';

class BeliBloc extends Bloc<BeliEvent, TransactionBeliState> {
  void onContinue() {
    dispatch(ContinueEvent());
  }

  void onBack() {
    dispatch(BackEvent());
  }
  
  void onSearchRate(String currencyCode, double rate, double volume) {
    dispatch(SearchRateEvent(currencyCode: currencyCode, rate: rate, volume: volume));
  }

  void onCancelSearch() {
    dispatch(CancelSearchEvent());
  }

  Future<TransactionModel> onInsert(String transactionCode, String currencyCode, String paymentCode, String locationCode, 
      String pickupCode, int userID, double rateTotal, double volumeTotal) async {
    TransactionModel bResult;
    Map<String, dynamic> jsonBody = {
        'transactionCode': transactionCode,
        'currencyCode': currencyCode,
        'paymentCode': paymentCode,
        'locationCode': locationCode,
        'pickupCode': pickupCode,
        'userID': userID.toString(),
        'rateTotal': rateTotal.toString(),
        'volumeTotal': volumeTotal.toString(),
      };
    await APIWeb().post(TransactionRepository.insert(jsonBody))
        .then((resp) {
        bResult = resp;
      }).catchError((onError) {
        bResult = null;
      });
      
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

  @override
  TransactionBeliState get initialState => TransactionBeliState.initial();

  @override
  Stream<TransactionBeliState> mapEventToState(BeliEvent event) async* {
    final _currentState = currentState;
    if (event is ContinueEvent) {
      yield TransactionBeliState(currentStep: _currentState.currentStep + 1, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: _currentState.visibilityFormInput, visibilityFormResult: _currentState.visibilityFormResult, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction);
    } else if (event is BackEvent) {
      yield TransactionBeliState(currentStep: _currentState.currentStep - 1, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: _currentState.visibilityFormInput, visibilityFormResult: _currentState.visibilityFormResult, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction);
    } else if (event is SearchRateEvent) {
      Map<String, dynamic> jsonBody = {
        'amount': event.volume.toString().replaceAll(".0", ""),
        'rate': event.rate.toString().replaceAll(".0", ""),
      };
      final data = await APIWeb().post(TransactionRepository.getDataFind(jsonBody));
      yield TransactionBeliState(currentStep: _currentState.currentStep, rate: event.rate, volume: event.volume,
              visibilityFormInput: data == null ? true : false, visibilityFormResult: data == null ? false : true, currencyResult: "avail", transaction: data);
    }else if (event is CancelSearchEvent){
      yield TransactionBeliState(currentStep: _currentState.currentStep, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: true, visibilityFormResult: false, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction);
    }else if (event is BookRateEvent){
      yield TransactionBeliState(currentStep: _currentState.currentStep,rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: true, visibilityFormResult: false, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction);
    }
  }

}


abstract class BeliEvent {}

class ContinueEvent extends BeliEvent {}

class BackEvent extends BeliEvent {}

class DropdownEvent extends BeliEvent {}

class CancelSearchEvent extends BeliEvent {}

class CurrencyChangeEvent extends BeliEvent {
  final String currencyCode;

  CurrencyChangeEvent({this.currencyCode});
}

class SearchRateEvent extends BeliEvent  {
  final String currencyCode;
  final double rate;
  final double volume;

  SearchRateEvent({this.currencyCode, this.rate, this.volume});
}

class InsertEvent extends BeliEvent{
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

class BookRateEvent extends BeliEvent {}

class TransactionBeliState {
  final int currentStep;
  final double rate;
  final double volume;
  final bool visibilityFormResult, 
      visibilityFormInput;
  final List<RateModel> transaction;
  final String currencyResult;
  
  const TransactionBeliState({this.currentStep = 0, this.rate = 0, this.volume = 0, this.visibilityFormInput = true, 
       this.visibilityFormResult = false, this.currencyResult, this.transaction});

  factory TransactionBeliState.initial() => TransactionBeliState(currentStep: 0);
}

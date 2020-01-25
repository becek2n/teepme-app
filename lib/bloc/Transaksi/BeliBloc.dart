import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/TrasansactionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/CurrencyModel.dart';
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

  @override
  TransactionBeliState get initialState => TransactionBeliState.initial();

  @override
  Stream<TransactionBeliState> mapEventToState(BeliEvent event) async* {
    final _currentState = currentState;
    if (event is ContinueEvent) {
      yield TransactionBeliState(currentStep: _currentState.currentStep + 1, currencyCode: _currentState.currencyCode, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: _currentState.visibilityFormInput, visibilityFormResult: _currentState.visibilityFormResult,
              currencyController: _currentState.currencyController, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction,
              currencyData: _currentState.currencyData);
    } else if (event is BackEvent) {
      yield TransactionBeliState(currentStep: _currentState.currentStep - 1, currencyCode: _currentState.currencyCode, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: _currentState.visibilityFormInput, visibilityFormResult: _currentState.visibilityFormResult,
              currencyController: _currentState.currencyController, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction,
              currencyData: _currentState.currencyData);
    } else if (event is SearchRateEvent) {
      Map<String, dynamic> jsonBody = {
        'amount': event.volume.toString().replaceAll(".0", ""),
        'rate': event.rate.toString().replaceAll(".0", ""),
      };
      final data = await APIWeb().post(TransactionRepository.getDataFind(jsonBody));
      yield TransactionBeliState(currentStep: _currentState.currentStep, currencyCode: event.currencyCode, rate: event.rate, volume: event.volume,
              visibilityFormInput: data == null ? true : false, visibilityFormResult: data == null ? false : true,
              currencyController: _currentState.currencyController, currencyResult: "avail", transaction: data,
              currencyData: _currentState.currencyData);
    }else if (event is CancelSearchEvent){
      yield TransactionBeliState(currentStep: _currentState.currentStep, currencyCode: _currentState.currencyCode, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: true, visibilityFormResult: false,
              currencyController: _currentState.currencyController, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction,
              currencyData: _currentState.currencyData);
    }else if (event is BookRateEvent){
      yield TransactionBeliState(currentStep: _currentState.currentStep, currencyCode: _currentState.currencyCode, rate: _currentState.rate, volume: _currentState.volume,
              visibilityFormInput: true, visibilityFormResult: false,
              currencyController: _currentState.currencyController, currencyResult: _currentState.currencyResult, transaction: _currentState.transaction,
              currencyData: _currentState.currencyData);
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

class BookRateEvent extends BeliEvent {}

class TransactionBeliState {
  final int currentStep;
  final String currencyCode;
  final double rate;
  final double volume;
  final bool visibilityFormResult, 
      visibilityFormInput;
  final String currencyController;
  final List<TransactionModel> transaction;
  final List<CurrencyModel> currencyData;
  final String currencyResult;
  
  //process payment
  final String paymentCode;
  final String locationCode;
  final String pickupCode;
  final String userName;

  const TransactionBeliState({  this.currentStep = 0, this.currencyCode, this.rate = 0, this.volume = 0, this.visibilityFormInput = true, 
       this.visibilityFormResult = false, this.currencyController, this.currencyResult, this.transaction, this.currencyData,
       this.paymentCode, this.locationCode, this.pickupCode, this.userName});

  factory TransactionBeliState.initial() => TransactionBeliState(currentStep: 0);
}

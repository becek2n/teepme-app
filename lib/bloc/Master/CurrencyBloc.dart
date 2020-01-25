import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/CurrencyRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/CurrencyModel.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  void onGetData() {
    dispatch(GetCurrencyEvent());
  }

  void onSelected(CurrencyModel model) {
    dispatch(CurrencySelectedEvent(model));
  }
  
  @override
  CurrencyState get initialState => CurrencyState.initial();

  @override
  Stream<CurrencyState> mapEventToState(CurrencyEvent event) async* {
    if (event is GetCurrencyEvent) {
      final data = await APIWeb().load(CurrencyRepository.getData);
      yield CurrencyState(list: data, currencyModel: currentState.currencyModel);
    }else if (event is CurrencySelectedEvent) {
      yield CurrencyState(list: currentState.list, currencyModel: event.model);
    }
  }

}

//event
abstract class CurrencyEvent {}

class GetCurrencyEvent extends CurrencyEvent {}

class CurrencySelectedEvent extends CurrencyEvent {
  final CurrencyModel model;
  
  CurrencySelectedEvent(this.model);
}

//state
class CurrencyState {
  final List<CurrencyModel> list;
  final CurrencyModel currencyModel;
  const CurrencyState({this.list, this.currencyModel});

  factory CurrencyState.initial() => CurrencyState();
}

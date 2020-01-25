import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/PaymentRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/PaymentModel.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  void onGetData() {
    dispatch(GetPaymentEvent());
  }
  void onPaymentSelected(PaymentModel model, bool isSelected) {
    dispatch(PaymentSelectedEvent(model, isSelected));
  }
  
  @override
  PaymentState get initialState => PaymentState.initial();

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is GetPaymentEvent) {
      final data = await APIWeb().load(PaymentRepository.getData);
      yield PaymentState(payment: currentState.payment, paymentList: data, isPaymentSelected: currentState.isPaymentSelected);
    }else if (event is PaymentSelectedEvent){
      yield PaymentState(payment: event.model, paymentList: currentState.paymentList, isPaymentSelected: event.isSelected);
    }
  }

}

//event
abstract class PaymentEvent {}

class GetPaymentEvent extends PaymentEvent {}

class PaymentSelectedEvent extends PaymentEvent {
  final PaymentModel model;
  final bool isSelected;

  PaymentSelectedEvent(this.model, this.isSelected);
}


//state
class PaymentState {
  final List<PaymentModel> paymentList;
  final PaymentModel payment;
  final bool isPaymentSelected;

  const PaymentState({this.paymentList, this.payment, this.isPaymentSelected});

  factory PaymentState.initial() => PaymentState();
}

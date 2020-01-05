import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/PromotionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/PromotionModel.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  
  void onGetData() {
    dispatch(GetPromotionEvent());
  }

  @override
  PromotionState get initialState => PromotionState.initial();

  @override
  Stream<PromotionState> mapEventToState(PromotionState state, PromotionEvent event) async* {
    if (event is GetPromotionEvent) {
      final data = await APIWeb().load(PromotionRepository.getData);
      yield PromotionState(promotionList: data);
    }
  }

}

//event
abstract class PromotionEvent {}

class GetPromotionEvent extends PromotionEvent {}


//state
class PromotionState {
  final List<PromotionModel> promotionList;

  const PromotionState({this.promotionList});

  factory PromotionState.initial() => PromotionState();
}

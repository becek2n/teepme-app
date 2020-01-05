import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/LocationRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/LocationModel.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  void onGetData() {
    dispatch(GetLocationEvent());
  }

  void onSearchLocation(String query, List<LocationModel> list) {
    dispatch(SearchLocation(query, list));
  }

  void onLocationSelected(LocationModel model) {
    dispatch(LocationSelectedEvent(model));
  }
  
  @override
  LocationState get initialState => LocationState.initial();

  @override
  Stream<LocationState> mapEventToState(LocationState state, LocationEvent event) async* {
    if (event is GetLocationEvent) {
      final data = await APIWeb().load(LocationRepository.getData);
      yield LocationState(location: currentState.location, locationList: data);
    }else if (event is LocationSelectedEvent){
      yield LocationState(location: event.model, locationList: currentState.locationList);
    }else if (event is SearchLocation){
      List<LocationModel> modelList = <LocationModel>[];
      if (event.query.isNotEmpty){
        currentState.locationList.forEach((item) {
          if(item.name.toLowerCase().contains(event.query) || item.address.toLowerCase().contains(event.query)) {
              modelList.add(item);
            }
          }
        );
      }else{
        modelList = currentState.locationList;
      }
      yield LocationState(location: currentState.location, locationList: modelList);
    }
  }

}

//event
abstract class LocationEvent {}

class GetLocationEvent extends LocationEvent {}

class SearchLocation extends LocationEvent {
  final String query;
  final List<LocationModel> list;

  SearchLocation(this.query, this.list);
}

class LocationSelectedEvent extends LocationEvent {
  final LocationModel model;

  LocationSelectedEvent(this.model);
}


//state
class LocationState {
  final List<LocationModel> locationList;
  final LocationModel location;

  const LocationState({this.locationList, this.location});

  factory LocationState.initial() => LocationState();
}

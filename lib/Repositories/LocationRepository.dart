import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/LocationModel.dart';
import 'package:teepme/models/ResultModel.dart';

class LocationRepository{
  
  static APIService<List<LocationModel>> get getData {
    return APIService(
      url:  'location',
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => LocationModel.fromJSON(i)).toList();
      }
    );
  }
}

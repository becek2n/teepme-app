import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/PromotionModel.dart';
import 'package:teepme/models/ResultModel.dart';

class PromotionRepository{
  
  static APIService<List<PromotionModel>> get getData {
    return APIService(
      url:  'promotion',
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => PromotionModel.fromJSON(i)).toList();
      }
    );
  }
}

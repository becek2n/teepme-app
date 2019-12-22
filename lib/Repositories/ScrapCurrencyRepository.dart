import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/ResultModel.dart';
import 'package:teepme/models/ScrapCurrencyModel.dart';

class ScrapCurrencyRepository{
  
  static APIService<List<ScrapCurrencyModel>> get getData {
    return APIService(
      url:  'scrap/currency',
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => ScrapCurrencyModel.fromJSON(i)).toList();
      }
    );
  }
}

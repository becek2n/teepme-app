import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/CurrencyModel.dart';
import 'package:teepme/models/ResultModel.dart';

class CurrencyRepositories{
  
  static APIService<List<CurrencyModel>> get getData {
    return APIService(
      url:  'currencyshow',
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => CurrencyModel.fromJSON(i)).toList();
      }
    );
  }
}

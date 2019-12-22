import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/ResultModel.dart';
import 'package:teepme/models/TransactionModel.dart';

class TransactionRepository{
  
  static APIService<List<TransactionModel>> getDataFind(dynamic body) {
    return APIService(
      url:  'transaction/find/',
      body: body,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionModel.fromJSON(i)).toList();
      }
    );
  }
}

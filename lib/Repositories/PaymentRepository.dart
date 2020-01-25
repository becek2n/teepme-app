import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/PaymentModel.dart';
import 'package:teepme/models/ResultModel.dart';

class PaymentRepository{
  
  static APIService<List<PaymentModel>> get getData {
    return APIService(
      url:  'payment',
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => PaymentModel.fromJSON(i)).toList();
      }
    );
  }
}

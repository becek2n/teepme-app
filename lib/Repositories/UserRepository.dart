import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/ResultModel.dart';
import 'package:teepme/models/UserModel.dart';

class UserRepository{
  
  static APIService<List<UserModel>> getData(url) {
    return APIService(
      url:  url,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => UserModel.fromJSON(i)).toList();
      }
    );
  }

  static APIService<ResultModel> insert(String url, dynamic body) {
    return APIService(
      url:  url,
      body: body,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final responseJson = ResultModel.fromJSON(parsed); 
        return responseJson;
      }
    );
  }
}

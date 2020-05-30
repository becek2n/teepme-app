import 'dart:convert';

import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/ResultModel.dart';
import 'package:teepme/models/WalletModel.dart';
import 'package:teepme/models/TransactionModel.dart';

class TransactionRepository{
  
  //header
  static APIService<List<RateModel>> getDataFind(dynamic body) {
    return APIService(
      url:  'transaction/rate/',
      body: body,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => RateModel.fromJSON(i)).toList();
      }
    );
  }

  //rate search
  static APIService<List<WalletModel>> getDataRateFind(dynamic body) {
    return APIService(
      url:  'wallet/findrate/',
      body: body,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => WalletModel.fromJSON(i)).toList();
      }
    );
  }

  static APIService<List<TransactionModel>> getAll() {
    return APIService(
      url:  'transaction/',
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionModel.fromJSON(i)).toList();
      }
    );
  }

  static APIService<List<TransactionModel>> getByUserId(String userID, int pageSize, int pageIndex) {
    return APIService(
      url:  'transaction/user/' + userID + "/" + pageSize.toString() + '/' + pageIndex.toString(),
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionModel.fromJSON(i)).toList();
      }
    );
  }

  static APIService<TransactionModel> getByID(String uid) {
    return APIService(
      url:  'transaction/id/' + uid,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionModel.fromJSONDetail(i)).single;
      }
    );
  }

  static APIService<TransactionModel> insert(dynamic body) {
    return APIService(
      url:  'transaction/insert/',
      body: body,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionModel.fromJSON(i)).single;
      }
    );
  }

  //detail
  static APIService<bool> insertDetail(dynamic body) {
    bool bresult = false;
    return APIService(
      url:  'transaction/insert/detail',
      body: body,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        if (dataJson.responsemessage == "Ok"){
          bresult = true;
        }
        return bresult;
      }
    );
  }

  static APIService<List<TransactionDetailModel>> getDetailByID(String trxCode) {
    return APIService(
      url:  'transaction/detail/' + trxCode,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionDetailModel.fromJSON(i)).toList();
      }
    );
  }

  static APIService<ResultModel> postData(String url, dynamic body) {
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

  //TRANSACTION TEMP
  static APIService<List<TransactionTempModel>> getDataTemp(String userID) {
    return APIService(
      url:  'transaction/temp/' + userID,
      parse: (response) {
        final parsed = json.decode(response.body); 
        final dataJson = ResultModel.fromJSON(parsed);
        return dataJson.responsedata.map((i) => TransactionTempModel.fromJSON(i)).toList();
      }
    );
  }
  
}

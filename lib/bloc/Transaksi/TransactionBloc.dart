import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/TrasansactionRepository.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:teepme/globals.dart' as globals;

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  void onGetData() {
    dispatch(GetTransactionEvent());
  }

  void onGetDataByID(String uid) {
    dispatch(GetTransactionIDEvent(uid));
  }

  void onGetDataByUserID(String userid, int pageSize, int pageIndex) {
    dispatch(GetTransactionByUserIDEvent(userid, pageSize, pageIndex));
  }

  void onGetDataDetailByID(String trxCode) {
    dispatch(GetTransactionDetailIDEvent(trxCode));
  }

  Future<bool> onUploadResi(File image, String transactionUID, int statusCodeFile, String userID) async{
    bool bResult = false;
    try{
      final String urlHost = globals.urlAPI + "transaction/file/"; 
      final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
      final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(urlHost));
      final file = await http.MultipartFile.fromPath('fileupload', image.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      imageUploadRequest.fields['TransactionUID'] = transactionUID;
      imageUploadRequest.fields['StatusCodeFile'] = statusCodeFile.toString();
      imageUploadRequest.fields['userID'] = userID;
      imageUploadRequest.files.add(file);
      final data = await imageUploadRequest.send();
      final response = await http.Response.fromStream(data);
      if (response.statusCode == 200) {
        return true;
      }
    }catch(e){
      bResult = false;
    }
    return bResult;
  }
  
  @override
  TransactionState get initialState => TransactionState.initial();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is GetTransactionEvent) {
      try{
        final data = await APIWeb().load(TransactionRepository.getAll());
        yield TransactionState(transactionList: data);
      }catch(ex){
        yield GetTransactionFailure(ex.toString());
      }
    }else if (event is GetTransactionByUserIDEvent) {
      try{
        final data = await APIWeb().load(TransactionRepository.getByUserId(event.userID, event.pageSize, event.pageIndex));
        yield TransactionState(transactionList: data);
      }catch(ex){
        yield GetTransactionFailure(ex.toString());
      }
    }else if (event is GetTransactionIDEvent){
      try{
        final data = await APIWeb().load(TransactionRepository.getByID(event.uid));
        yield TransactionState(transactionModel: data);
      }catch(ex){
        yield GetTransactionFailure(ex.toString());
      }
    }else if (event is GetTransactionDetailIDEvent){
      try{
        final data = await APIWeb().load(TransactionRepository.getDetailByID(event.trxCode));
        yield TransactionState(transactionDetailList: data);
      }catch(ex){
        yield GetTransactionFailure(ex.toString());
      }
    }
  }

}

//event
abstract class TransactionEvent {}

class GetTransactionEvent extends TransactionEvent {}

class GetTransactionByUserIDEvent extends TransactionEvent {
  final String userID;
  final int pageSize;
  final int pageIndex;
  GetTransactionByUserIDEvent(this.userID, this.pageSize, this.pageIndex);
}

class GetTransactionIDEvent extends TransactionEvent {
  final String uid;

  GetTransactionIDEvent(this.uid);
}

class GetTransactionDetailIDEvent extends TransactionEvent {
  final String trxCode;

  GetTransactionDetailIDEvent(this.trxCode);
}


//state
class TransactionState {
  final List<TransactionModel> transactionList;
  final TransactionModel transactionModel;
  final List<TransactionDetailModel> transactionDetailList;
  
  const TransactionState({this.transactionList, this.transactionModel, this.transactionDetailList});

  factory TransactionState.initial() => TransactionState();
}

class GetTransactionFailure extends TransactionState {
  final String error;

  GetTransactionFailure(this.error);
}
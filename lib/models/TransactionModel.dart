import 'package:teepme/models/PickupModel.dart';

class RateModel {
  final String uid;
  final String userName;
  final double amountAvail;
  final double rate;
  final double amountTotal;

  RateModel.fromJSON(Map<String, dynamic> jsonMap) :
    uid = jsonMap['uid'],
    userName= jsonMap['username'],
    amountAvail = double.parse(jsonMap['amountavail']),
    rate = double.parse(jsonMap['rate']),
    amountTotal = double.parse(jsonMap['amounttotal']);
}

class TransactionTempModel {
  final String userID;
  final String uidWallet;
  final String currencyCode;
  final int volume;
  final double rate;

  TransactionTempModel({this.userID, this.uidWallet, this.currencyCode, this.volume, this.rate});
  TransactionTempModel.fromJSON(Map<String, dynamic> jsonMap) :
    userID = jsonMap['UserID'],
    uidWallet = jsonMap['UIDWallet'],
    currencyCode = jsonMap['CurrencyCode'],
    volume = int.parse(jsonMap['Volume'].toString()),
    rate = double.parse(jsonMap['Rate'].toString());
}

class TransactionModel {
  final String uid;
  final String transactionCode;
  final String currencyCode;
  final String paymentCode;
  final String locationCode;
  final String pickupCode;
  final String userName;
  final double amountTotal;
  final double volumeTotal;
  final String currencyName;
  final String paymentName;
  final String locationName;
  final String pickupName;
  final String transactionTypeCode;
  final String verificationCode;
  final int statusCode;
  final String status;

  final List<TransactionDetailModel> transactionDetailModel;
  final PickupInfoModel pickupInfo;
  final TransactionFileModel transactionFileInfo;

  TransactionModel(
    {
      this.uid, this.transactionCode, this.currencyCode, this.paymentCode, this.locationCode, this.pickupCode, 
      this.userName, this.amountTotal, this.volumeTotal, this.currencyName, this.paymentName, this.locationName, this.pickupName, 
      this.transactionTypeCode, this.verificationCode,
      this.statusCode, this.status, this.transactionDetailModel, this.pickupInfo, this.transactionFileInfo
    }
  );

  factory TransactionModel.fromJSON(Map<String, dynamic> jsonMap) {
    return TransactionModel(
      uid: jsonMap['UID'],
      transactionCode: jsonMap['TransactionCode'],
      currencyCode: jsonMap['CurrencyCode'],
      paymentCode: jsonMap['PaymentCode'],
      locationCode: jsonMap['LocationCode'],
      pickupCode: jsonMap['PickupCode'],
      userName: jsonMap['Username'],
      amountTotal: double.parse(jsonMap['AmountTotal']),
      volumeTotal: double.parse(jsonMap['VolumeTotal']),
      currencyName: jsonMap['CurrencyName'],
      paymentName: jsonMap['PaymentName'],
      locationName: jsonMap['LocationName'],
      pickupName: jsonMap['PickupName'],
      transactionTypeCode: jsonMap['TransactionTypeCode'],
      verificationCode: jsonMap['VerificationCode'],
      statusCode: jsonMap['StatusCode'],
      status: jsonMap['Status']    
    );
  }

  factory TransactionModel.fromJSONDetail(Map<String, dynamic> jsonMap) {
    var listDetailInfo = jsonMap['DetailInfo'] as List;
    List<TransactionDetailModel> listDetail = listDetailInfo.map((i) => TransactionDetailModel.fromJSON(i)).toList();

    var pickupInfos = jsonMap['PickupInfo'] as List;
    PickupInfoModel pickupInfo = pickupInfos.map((i) => PickupInfoModel.fromJSON(i)).single;

    var transactionFileInfos = jsonMap['TransactionFileInfo'] as List;
    TransactionFileModel transactionFileInfo = transactionFileInfos.map((i) => TransactionFileModel.fromJSON(i)).single; 

    return TransactionModel(
      uid: jsonMap['UID'],
      transactionCode: jsonMap['TransactionCode'],
      currencyCode: jsonMap['CurrencyCode'],
      paymentCode: jsonMap['PaymentCode'],
      locationCode: jsonMap['LocationCode'],
      pickupCode: jsonMap['PickupCode'],
      userName: jsonMap['Username'],
      amountTotal: double.parse(jsonMap['AmountTotal']),
      volumeTotal: double.parse(jsonMap['VolumeTotal']),
      currencyName: jsonMap['CurrencyName'],
      paymentName: jsonMap['PaymentName'],
      locationName: jsonMap['LocationName'],
      pickupName: jsonMap['PickupName'],
      transactionTypeCode: jsonMap['TransactionTypeCode'],
      verificationCode: jsonMap['VerificationCode'],
      statusCode: jsonMap['StatusCode'],
      status: jsonMap['Status'],
      transactionDetailModel: listDetail,
      pickupInfo: pickupInfo,
      transactionFileInfo: transactionFileInfo
    );
  }
    
}

class TransactionDetailModel {
  final String uid;
  final String transactionUID;
  final String uidWallet;
  final double rate;
  final double amount;

  TransactionDetailModel({this.uid, this.transactionUID, this.uidWallet, this.rate, this.amount });
  
  factory TransactionDetailModel.fromJSON(Map<String, dynamic> jsonMap) {
    return TransactionDetailModel(
      uid: jsonMap['UID'],
      transactionUID: jsonMap['TransactionUID'],
      uidWallet: jsonMap['UIDWallet'],
      rate: double.parse(jsonMap['Rate'].toString()),
      amount: double.parse(jsonMap['Amount'].toString())
    );
  }
    
}

class TransactionFileModel {
  final String uid;
  final String transactionUID;
  final String fileName;
  final String filePath;
  final String fileType;
  final int statusCodeFile;
  final String status;

  TransactionFileModel.fromJSON(Map<String, dynamic> jsonMap) :
    uid = jsonMap['UID'],
    transactionUID= jsonMap['TransactionUID'],
    fileName= jsonMap['FileName'],
    filePath= jsonMap['FilePath'],
    fileType= jsonMap['FileType'],
    statusCodeFile= jsonMap['StatusCodeFile'],
    status= jsonMap['Status']
  ;
}

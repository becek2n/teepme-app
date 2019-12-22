class TransactionModel {
  final String uid;
  final String userName;
  final String amountAvail;
  final String rate;
  final String amountTotal;

  TransactionModel.fromJSON(Map<String, dynamic> jsonMap) :
    uid = jsonMap['uid'],
    userName= jsonMap['username'],
    amountAvail = jsonMap['amountavail'],
    rate = jsonMap['rate'],
    amountTotal = jsonMap['amounttotal'];
}
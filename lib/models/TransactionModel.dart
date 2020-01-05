class TransactionModel {
  final String uid;
  final String userName;
  final double amountAvail;
  final double rate;
  final double amountTotal;

  TransactionModel.fromJSON(Map<String, dynamic> jsonMap) :
    uid = jsonMap['uid'],
    userName= jsonMap['username'],
    amountAvail = double.parse(jsonMap['amountavail']),
    rate = double.parse(jsonMap['rate']),
    amountTotal = double.parse(jsonMap['amounttotal']);
}
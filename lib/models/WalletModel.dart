class WalletModel {
  final String uid;
  final String userName;
  final String currencyCode;
  final double amount;
  final double amountAvail;
  final double rate;

  WalletModel.fromJSON(Map<String, dynamic> jsonMap) :
    uid = jsonMap['uid'],
    userName = jsonMap['username'],
    currencyCode = jsonMap['currencycode'],
    amount = double.parse(jsonMap['amount']),
    amountAvail = double.parse(jsonMap['amountavail']),
    rate = double.parse(jsonMap['rate']);
}
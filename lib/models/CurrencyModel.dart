class CurrencyModel {
  final String currencyCode;
  final String symbol;
  final String name;
  final String symbolNative;
  final String decimalDigits;
  final String rouding;
  final String namePlural;

  CurrencyModel.fromJSON(Map<String, dynamic> jsonMap) :
    currencyCode = jsonMap['currencycode'],
    symbol = jsonMap['symbol'],
    name = jsonMap['name'],
    symbolNative = jsonMap['symbol_native'],
    decimalDigits = jsonMap['decimal_digits'],
    rouding = jsonMap['rouding'],
    namePlural = jsonMap['name_plural'];
}
class ScrapCurrencyModel {
  final String id;
  final String name;
  final String max;
  final String average;
  final String volume;
  final String symbol;
  final String dateActive;
  final String isActive;

  ScrapCurrencyModel.fromJSON(Map<String, dynamic> jsonMap) :
    id = jsonMap['ID'],
    name = jsonMap['Name'],
    max = jsonMap['Max'],
    average = jsonMap['Average'],
    volume = jsonMap['Volume'],
    symbol = jsonMap['Symbol'],
    dateActive = jsonMap['DateActive'],
    isActive = jsonMap['IsAcrive'];
}
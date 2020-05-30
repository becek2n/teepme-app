class PickupModel
{
  final String pickupCode;
  final String pickupName;
  final double amount;

  PickupModel({this.pickupCode, this.pickupName, this.amount});

  factory PickupModel.fromJSON(Map<String, dynamic> jsonMap){
    return PickupModel(
      pickupCode: jsonMap["PickupCode"],
      pickupName: jsonMap["PickupName"],
      amount: double.parse(jsonMap["Amount"].toString()),
    );
  }

}

class PickupInfoModel
{
  final String locationCode;
  final String locationImage;
  final String locationName;
  final String locationAddress;
  final String pickupCode;
  final String pickupName;
  final double pickupAmount;

  PickupInfoModel({
    this.locationCode,
    this.locationImage,
    this.locationName,
    this.locationAddress,
    this.pickupCode,
    this.pickupName,
    this.pickupAmount
  });

  factory PickupInfoModel.fromJSON(Map<String, dynamic> jsonMap) 
  {
    final data = PickupInfoModel( 
      locationCode: jsonMap["LocationCode"],
      locationImage: jsonMap["LocationImages"],
      locationName: jsonMap["LocationName"],
      locationAddress: jsonMap["LocationAddress"],
      pickupCode: jsonMap["PickupCode"],
      pickupName: jsonMap["PickupName"],
      pickupAmount: double.parse(jsonMap["Amount"].toString())
      );
    return data;
  }
  
  
  
}

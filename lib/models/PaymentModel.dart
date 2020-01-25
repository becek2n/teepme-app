class PaymentModel {
  final String paymentCode;
  final String name;
  final String desc;
  final String image;

  PaymentModel({
    this.paymentCode,
    this.name,
    this.desc,
    this.image
  });
  factory PaymentModel.fromJSON(Map<String, dynamic> jsonMap) 
  {
    final data = PaymentModel(
      paymentCode: jsonMap['PaymentCode'],
      name: jsonMap['Name'],
      desc: jsonMap['Desc'],
      image: jsonMap['Image']
    );
    return data;
  }
    
}
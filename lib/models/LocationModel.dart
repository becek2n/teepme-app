class LocationModel
{
    final int id;
    final String locationCode;
    final String image;
    final String name;
    final String address;
    final double latitude;
    final double longitude;

    LocationModel({
      this.id,
      this.locationCode,
      this.image,
      this.name,
      this.address,
      this.latitude,
      this.longitude
    });

    factory LocationModel.fromJSON(Map<String, dynamic> jsonMap) 
    {
      final data = LocationModel( 
        id: jsonMap["ID"],
        locationCode: jsonMap["LocationCode"],
        image: jsonMap["LocationImages"],
        name: jsonMap["LocationName"],
        address: jsonMap["LocationAddress"],
        latitude: double.parse(jsonMap["latitude"]),
        longitude: double.parse(jsonMap["longitude"]));
      return data;
    }

}

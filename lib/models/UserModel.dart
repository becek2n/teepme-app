class UserModel
{
    final int id;
    final String userName;
    final String password;
    final String fullName;
    final String email;
    final String phone;
    final String address;
    final String city;
    final String countryCode;
    final String photo;
    final int roleID;
    final String activationCode;
    final int statusCode;
    final DateTime dateCreated;
    final String createdBy;
    final DateTime dateModified;
    final String modifiedBy;

    UserModel({
      this.id,
      this.userName,
      this.password,
      this.fullName,
      this.email,
      this.phone,
      this.address,
      this.city,
      this.countryCode,
      this.photo,
      this.roleID,
      this.activationCode,
      this.statusCode,
      this.dateCreated,
      this.createdBy,
      this.dateModified,
      this.modifiedBy,
    });

    factory UserModel.fromJSON(Map<String, dynamic> jsonMap) 
    {
      final data = UserModel( 
        id: jsonMap["ID"],
        userName: jsonMap["UserName"],
        password: jsonMap["Password"],
        fullName: jsonMap["FullName"],
        email: jsonMap["Email"],
        phone: jsonMap["Phone"],
        address: jsonMap["Address"],
        city: jsonMap["City"],
        countryCode: jsonMap["CountryCode"],
        photo: jsonMap["Photo"],
        roleID: jsonMap["RoleID"],
        activationCode: jsonMap["ActivationCode"],
        statusCode: jsonMap["StatusCode"],
        dateCreated: jsonMap["DateCreated"],
        createdBy: jsonMap["CreatedBy"],
        dateModified: jsonMap["DateModified"],
        modifiedBy: jsonMap["ModifiedBy"]
      );
      return data;
    }

    Map<String, dynamic> mapToDbClient(){
      return {
        'id': this.id,
        'username': this.userName,
        'password': this.password
      };
    }

    factory UserModel.fromMap(Map<String, dynamic> map) {
      final data = UserModel(
        id: map["id"],
        userName: map["username"],
        password: map["password"]
      );
      return data;
    }
}

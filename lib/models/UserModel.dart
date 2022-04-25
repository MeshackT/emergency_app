class UserModel {
  String? uid;
  String? email;
  String? phoneNumber;
  String? password;
  String? fullName;
  String? address;

  UserModel.name(this.email, this.phoneNumber, this.fullName, this.address);

  UserModel(
      {this.uid,
      this.email,
      this.phoneNumber,
      this.password,
      this.fullName,
      this.address});

  @override
  String toString() {
    return 'Details\n\nemail: $email\nphoneNumber: $phoneNumber\n'
        '\nfullName: $fullName\n\naddress: $address';
  }

  //getting data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      fullName: map['fullName'],
      // password: map['password'],
      address: map['address'],
    );
  }

  // Map<String, dynamic> userModel = {};

  //sending data to the server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'fullName': fullName,
      'address': address,
    };
  }
}

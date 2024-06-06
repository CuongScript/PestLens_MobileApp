class User {
  String username;
  String email;
  String firstName;
  String lastName;
  String profileImageUrl;
  String farmName;
  String phoneNumber;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.farmName,
    required this.phoneNumber,
  });

  // Method to create a User object from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'],
      farmName: json['farmName'],
      phoneNumber: json['phoneNumber'],
    );
  }

  // Method to convert a User object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'farmName': farmName,
      'phoneNumber': phoneNumber,
    };
  }
}

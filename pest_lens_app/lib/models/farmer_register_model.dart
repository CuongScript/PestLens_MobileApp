class FarmerRegisterModel {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? avatarUrl;

  FarmerRegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl ?? '',
    };
  }

  FarmerRegisterModel copyWith({
    String? username,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return FarmerRegisterModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  String toString() {
    return 'UserRegisterModel(username: $username, email: $email, password: $password, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl)';
  }

  factory FarmerRegisterModel.fromJson(Map<String, dynamic> json) {
    return FarmerRegisterModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

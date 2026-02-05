// "_id": "67adf258363796466241bfb9",
// "first_name": "Meskatul",
// "last_name": "Islam",
// "email": "meskatcse@gmail.com",
// "phone": "01754658781",
// "avatar_url": null,
// "city": "Chattogram",

import 'package:crafty_bay/features/auth/presentation/providers/auth_controller.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String city;
  final String? photo;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.city,
    this.photo
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phone: json['phone'],
        avatarUrl: json['avatar_url'],
        city: json['city'],
        photo: json['photo']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone":phone,
      'avatar_url': avatarUrl,
      "city": city,
      "photo": photo,
    };
  }
}

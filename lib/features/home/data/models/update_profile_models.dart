// "first_name": "Meskatul",
// "last_name": "Islam",
// "phone": "01754658781",
// "city": "Chattogram"

import 'dart:convert';
import 'dart:io';

class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  final File? selectedImage;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
    this.selectedImage,
  });

  String? encodedPhoto;
  Future<Map<String, dynamic>> toRequestBody() async{
    final Map<String, dynamic> requestBody = {
      'first_name': firstName,
      'last_name': lastName,
      'phone':phone,
      'city': city
    };
    if(selectedImage != null) {
      List<int> bytes = await selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }
    return requestBody;
  }
}

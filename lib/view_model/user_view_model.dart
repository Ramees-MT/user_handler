import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_handler/api/api_const.dart';
import 'package:user_handler/model/user_model.dart';


class UserProvider with ChangeNotifier {
  static  String Url = '$baseurl/create';

  bool _isLoading = false;
  String? _errorMessage;
  User? _createdUser;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get createdUser => _createdUser;

  
  Future<void> createUser({required String name, required String email, required String address,required BuildContext context}) async {
    _isLoading = true;
    _errorMessage = null;
    _createdUser = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(Url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "address": address,
        }),
      );

      if (response.statusCode == 200 ) {
        final data = jsonDecode(response.body);
        _createdUser = User.fromJson(data);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User already existS')));
        _errorMessage = 'Failed to fetch users. Please try again.';;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

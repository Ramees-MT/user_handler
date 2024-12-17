import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_handler/api/api_const.dart';
import 'package:user_handler/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<User> users = [];

 
  Future<void> fetchUsers(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseurl/viewcreatedusers'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users = data.map((userJson) => User.fromJson(userJson)).toList();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$errorMessage')));
        errorMessage = 'Failed to fetch users. Please try again.';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

 Future<void> deleteUser(String userId) async {
  try {
    final response = await http.delete(Uri.parse('$baseurl/delete/$userId'));

    if (response.statusCode == 201) {
      users.removeWhere((user) => user.id == userId);
      notifyListeners();
    } else {
      errorMessage = "Failed to delete user. Server error.";
      notifyListeners();
    }
  } catch (error) {
    String errorMsg = "An unexpected error occurred.";
    if (error is SocketException) {
      errorMsg = "No internet connection. Please check your network.";
    } else if (error is TimeoutException) {
      errorMsg = "Request timed out. Please try again.";
    } else if (error is FormatException) {
      errorMsg = "Invalid response format.";
    }
    errorMessage = errorMsg;
    notifyListeners();
  }
}


}

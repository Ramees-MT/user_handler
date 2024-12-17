import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:user_handler/api/api_const.dart';
import 'package:user_handler/model/user_model.dart';
import 'package:user_handler/view_model/userview_view_model.dart';

class UserUpdateViewModel extends ChangeNotifier {
  String? errorMessage;
  bool isLoading = false;

  // Loading state

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData,
      BuildContext context, List<User> users, UserViewModel userViewModel) async {
    isLoading = true;
    notifyListeners(); // Notify UI about loading state

    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      final body = json.encode(updatedData);
      final url = Uri.parse('$baseurl/update/$userId');

      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        final updatedUser = User.fromJson(json.decode(response.body));
        final userIndex = users.indexWhere((user) => user.id == userId);
        if (userIndex != -1) {
          users[userIndex] = updatedUser;
        }

        notifyListeners();
        userViewModel.notifyListeners(); // Notify UserViewModel

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // Pop the screen
      } else {
        errorMessage = "Failed to update user. Server error.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      errorMessage = "Failed to update user. Network error.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading = false; // Reset loading state
      notifyListeners();
    }
  }
}



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottoproject/config/apitest.dart';
import 'package:lottoproject/model/res/GetUsers_id.dart';

class AppData with ChangeNotifier {
  late GetUsers users_id; 
  String userEmail = ''; 
  int id = 0;

  GetUsers get user => users_id;  

  Future<void> fetchUserProfile(int id) async {
    final url = Uri.parse('$SERVER/users/$id');  
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        users_id = GetUsers.fromJson(data);

        notifyListeners();
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  void updateUserWallet(int newWalletAmount) {
    users_id.userWallet = newWalletAmount;
    notifyListeners(); 
  }
}

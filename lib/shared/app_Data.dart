import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottoproject/config/apitest.dart';
import 'package:lottoproject/model/res/GetUsers_id.dart';

class AppData with ChangeNotifier {
  GetUsers? users_id;  // โมเดลที่เก็บข้อมูลจาก API
  String userEmail = ''; 
  int id = 0;  // id ที่ใช้ในการเรียก API

  GetUsers? get user => users_id;  // Getter เพื่อดึงข้อมูลผู้ใช้

  // ฟังก์ชันสำหรับการเรียก API รับ id เป็นพารามิเตอร์
  Future<void> fetchUserProfile(int id) async {
    final url = Uri.parse('$SERVER/users/$id');  // ใช้ id ใน URL
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // แปลงข้อมูล JSON เป็น object ของ GetUsers
        users_id = GetUsers.fromJson(data);

        // อัปเดตสถานะและแจ้งเตือน UI
        notifyListeners();
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }
}

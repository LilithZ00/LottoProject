// ignore_for_file: must_be_immutable, unused_local_variable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/config.dart';
import 'package:lottoproject/model/req/loginReq.dart';
import 'package:lottoproject/model/res/loginRES.dart';
import 'package:lottoproject/pages/AdminPage.dart';
import 'package:lottoproject/pages/HomePage.dart';
import 'package:lottoproject/pages/RegisterPage.dart';
import 'package:http/http.dart' as http;
import 'package:lottoproject/shared/app_Data.dart';
import 'package:lottoproject/shared/testpro.dart';
import 'package:provider/provider.dart';

//camp is here
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();

  final TextEditingController _idController = TextEditingController();

  String server = '';

  @override
  void initState() {
    super.initState();
    Config.getConfig().then(
      (value) {
        log(value['serverAPI']);
        setState(() {
          server = value['serverAPI'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Lotto',
                  style: TextStyle(
                    fontFamily: 'Lobster', // fontstyle
                    fontSize: 48,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: phoneCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Color(0xFFF0ECF6),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(30.0)), //ขอบมน
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passCtl,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Color(0xFFF0ECF6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 135, 0, 173),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => register(context),
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline, // เส้นใต้
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'Enter User ID'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    // เรียก API โดยส่ง id ที่ผู้ใช้กรอก
                    int id = int.parse(_idController.text);
                    context.read<AppData>().fetchUserProfile(id);
                  },
                  child: Text('Fetch User Profile'),
                ),
                Consumer<AppData>(
                  builder: (context, appData, child) {
                    // ตรวจสอบว่ามีข้อมูลผู้ใช้หรือไม่
                    if (appData.user != null) {
                      return Column(
                        children: [
                          Text('User ID: ${appData.user.userId}'),
                          Text('User Name: ${appData.user.userName}'),
                          Text('User Name: ${appData.user.userImage}'),
                        ],
                      );
                    } else {
                      return Text('No data');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    var data =
        CustomerLoginPostRequest(phone: phoneCtl.text, password: passCtl.text);
    http
        .post(
      Uri.parse('$server/users/login'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: customerLoginPostRequestToJson(data),
    )
        .then((value) {
      LoginRes response = loginResFromJson(value.body);
      log('Username: ${response.userName}');

      // ตรวจสอบประเภทของผู้ใช้
      if (response.userType == 'a') {
        // นำทางไปยังหน้า Admin
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(), // เปลี่ยนเป็นหน้า Admin
          ),
        );
      } else if (response.userType == 'c') {
        // นำทางไปยังหน้า User
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(idx: response.userId), // เปลี่ยนเป็นหน้า User
          ),
        );
      } else {
        // กรณีที่ไม่ตรงกับประเภทผู้ใช้ที่รู้จัก
        log('Unknown user role: ${response.userType}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown user role')),
        );
      }
    }).catchError((error) {
      log('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    });
  }

  void register(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
}

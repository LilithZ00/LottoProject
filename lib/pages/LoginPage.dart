// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/apitest.dart';
import 'package:lottoproject/model/req/loginReq.dart';
import 'package:lottoproject/model/res/loginRES.dart';
import 'package:lottoproject/pages/HomePage.dart';
import 'package:lottoproject/pages/RegisterPage.dart';
import 'package:http/http.dart' as http;

//camp is here
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // String phoneNum = '';
  // String passWord = '';

  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    // var phone = phoneCtl.text;
    // var pass = passCtl.text;

    // if(phone == "1" && pass =="1"){
    //   //   Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => const HomePage()),
    //   // );

    //   log('phone number and password match');
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));

    // }else if(phone == "0" && psass =="0"){
    //   log('phone number and password match');
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPage()));
    // }else{
    //   log("failed");
    // }

    var data =
        CustomerLoginPostRequest(phone: phoneCtl.text, password: passCtl.text);
    http
        .post(Uri.parse('$SERVER/users/login'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(data))
        .then(
      (value) {
        LoginRes response =
            loginResFromJson(value.body);
        log(response.userName);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                  idx: response.userId)), // แก้ไขเป็น ShowtripsPage
        );
      },
    ).catchError((err) {
      log("gg");
    });
  }

  register(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}

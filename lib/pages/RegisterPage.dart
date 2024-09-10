// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_const_constructors, library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/config.dart';
import 'package:lottoproject/model/res/registerRes.dart';
import 'package:lottoproject/pages/LoginPage.dart';
import 'package:lottoproject/model/req/registerReq.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // ต้องมีการนำเข้าแพ็กเกจนี้เพื่อใช้ jsonDecode

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController walletCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  bool isButtonEnabled = false;
  bool isLoading = false; // เพิ่มสถานะ isLoading

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
      appBar: AppBar(
        title: const Text('สมัครสมาชิก'),
        backgroundColor: Colors.purple[200],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: usernameCtl,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Color(0xFFF0ECF6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailCtl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Color(0xFFF0ECF6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Color(0xFFF0ECF6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passCtl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  filled: true,
                  fillColor: Color(0xFFF0ECF6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  register(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F0FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                      )
                    : const Text('สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register(BuildContext context) {
    if (usernameCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        passCtl.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ข้อมูลไม่ครบ'),
          content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง'),
          actions: <Widget>[
            TextButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return; // หยุดการทำงานต่อถ้าข้อมูลไม่ครบ
    }

    setState(() {
      isLoading = true; // เริ่มการโหลด
    });

    var data = RegisterRequset(
      username: usernameCtl.text,
      email: emailCtl.text,
      password: passwordCtl.text,
    );

    if (passwordCtl.text == passCtl.text) {
      http.get(
        Uri.parse('$server/shows'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      ).then((response) {
        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);

          if (responseData is List) {
            bool isEmailMatched = false;

            for (var item in responseData) {
              if (item is Map && item.containsKey('user_email')) {
                var userEmail = item['user_email'];

                if (emailCtl.text == userEmail) {
                  isEmailMatched = true;
                  break;
                }
              }
            }

            if (isEmailMatched) {
              setState(() {
                isLoading = false; // หยุดการโหลด
              });

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('อีเมลล์ซ้ำ'),
                  content: Text('อีเมลล์นี้มีอยู่ในระบบแล้ว กรุณาใช้อีเมลล์อื่น'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('ปิด'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              http
                  .post(
                Uri.parse('$server/users/register'),
                headers: {"Content-Type": "application/json; charset=utf-8"},
                body: registerRequsetToJson(data),
              )
                  .then((value) {
                RegisterRes response = registerResFromJson(value.body);

                setState(() {
                  isLoading = false; // หยุดการโหลด
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response.message)),
                );

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('สมัครสมาชิกเสร็จสิ้น'),
                    content: Text('การสมัครสมาชิกสำเร็จแล้ว'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('ตกลง'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).catchError((err) {
                setState(() {
                  isLoading = false; // หยุดการโหลด
                });

                log("Error during registration: $err");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('การลงทะเบียนล้มเหลว')),
                );
              });
            }
          } else {
            log('Unexpected data format: $responseData');
          }
        } else {
          log('Failed to load data: ${response.statusCode}');
        }
      }).catchError((error) {
        setState(() {
          isLoading = false; // หยุดการโหลด
        });

        log('Error: $error');
      });
    } else {
      setState(() {
        isLoading = false; // หยุดการโหลด
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('รหัสผ่านไม่ตรงกัน'),
          content: Text('กรุณากรอกรหัสผ่านให้ตรงกัน'),
          actions: <Widget>[
            TextButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}

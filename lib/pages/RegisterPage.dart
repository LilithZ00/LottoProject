// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/apitest.dart';
import 'package:lottoproject/model/res/registerRes.dart';
import 'package:lottoproject/pages/LoginPage.dart';
import 'package:lottoproject/model/req/registerReq.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController walletCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  bool isButtonEnabled = false;

  void checkFieldsFilled() {
    setState(() {
      isButtonEnabled = usernameCtl.text.isNotEmpty &&
          passCtl.text.isNotEmpty &&
          phoneCtl.text.isNotEmpty &&
          emailCtl.text.isNotEmpty &&
          walletCtl.text.isNotEmpty &&
          passwordCtl.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    usernameCtl.addListener(checkFieldsFilled);
    passCtl.addListener(checkFieldsFilled);
    phoneCtl.addListener(checkFieldsFilled);
    emailCtl.addListener(checkFieldsFilled);
    walletCtl.addListener(checkFieldsFilled);
    passwordCtl.addListener(checkFieldsFilled);
  }

  @override
  void dispose() {
    usernameCtl.dispose();
    passCtl.dispose();
    phoneCtl.dispose();
    emailCtl.dispose();
    walletCtl.dispose();
    passwordCtl.dispose();
    super.dispose();
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
                controller: phoneCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
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
              const SizedBox(height: 20),
              TextField(
                controller: walletCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Wallet',
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
                onPressed: isButtonEnabled ? () => register(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F0FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                ),
                child: const Text('สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register(BuildContext context) {
    var data = RegisterRequset(
      username: usernameCtl.text,
      phone: phoneCtl.text,
      email: emailCtl.text,
      password: passwordCtl.text,
      wallet: int.parse(walletCtl.text),
    );

    if (passwordCtl.text == passCtl.text) {
      log('match');
      http
          .post(
        Uri.parse('$SERVER/users/register'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: registerRequsetToJson(data),
      )
          .then((value) {
        RegisterRes response = registerResFromJson(value.body);
        log(response.message);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }).catchError((err) {
        log("gg");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('การลงทะเบียนล้มเหลว')),
        );
      });
    } else {
      log('not match');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
    }
  }
}

// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, use_super_parameters, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/apitest.dart';
import 'package:lottoproject/config/config.dart';
import 'package:lottoproject/model/req/InsertLotto.dart';
import 'dart:math';
import 'dart:developer' as dl;
import 'package:lottoproject/pages/LoginPage.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> prizeNumbers =
      List.filled(5, '000000'); // สร้างลิสต์สำหรับเก็บหมายเลขรางวัล
  bool areButtonsDisabled = false; // สถานะปุ่ม

  // สร้างเลขสุ่ม 6 หลัก
  String generateRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(900000) + 1;
    return randomNumber.toString().padLeft(6, '0');
  }

  // แสดงตัวเลขแบบมีช่องว่างระหว่างตัวเลข
  Widget buildSpacedNumber(String number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: number.split('').map((digit) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              const Text(
                'Admin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'รางวัลที่ 1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buildSpacedNumber(prizeNumbers[0]),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: [
                          const Text(
                            'รางวัลที่ 2',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: buildSpacedNumber(prizeNumbers[1]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'รางวัลที่ 3',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: buildSpacedNumber(prizeNumbers[2]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: [
                          const Text(
                            'รางวัลที่ 4',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: buildSpacedNumber(prizeNumbers[3]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'รางวัลที่ 5',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: buildSpacedNumber(prizeNumbers[4]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: areButtonsDisabled ? null : drawPrizes,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      areButtonsDisabled ? Colors.grey : Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'ออกผลรางวัลจากที่ขายไป',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: areButtonsDisabled ? null : drawPrizes,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      areButtonsDisabled ? Colors.grey : Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'ออกผลรางวัลจากทั้งหมด',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showResetDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'รีเซ็ตระบบ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => loginPage(context),
                child: const Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ออกผลรางวัล
  void drawPrizes() {
    setState(() {
      for (int i = 0; i < prizeNumbers.length; i++) {
        prizeNumbers[i] = generateRandomNumber();
      }
      areButtonsDisabled = true;
    });
  }

  // รีเซ็ตหมายเลขรางวัล
  void resetPrizes() {
    setState(() {
      prizeNumbers = List.filled(5, '000000');
      areButtonsDisabled = false;
    });
    Navigator.pop(context);
  }

  Future<void> showResetDialog(BuildContext context) async {
    // รอให้ผู้ใช้ตอบสนองต่อ Dialog ก่อนที่จะดำเนินการขั้นตอนต่อไป
    bool shouldGenerate = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Reset'),
          content: Text(
              'Do you want to delete all data and generate new random numbers?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // ส่งค่า false ถ้ากด Cancel
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true); // ส่งค่า true ถ้ากด OK
              },
            ),
          ],
        );
      },
    );

    // ตรวจสอบว่าผู้ใช้กด "OK" หรือไม่
    if (shouldGenerate) {
      final url =
          Uri.parse('https://node-api-lotto.vercel.app/lotto/deleteAllLottos');
      try {
        var response = await http.delete(
          url,
          headers: {
            "Content-Type": "application/json; charset=utf-8",
          },
        );
        if (response.statusCode == 200) {
          dl.log('Successfully deleted all lottos');
          // ดำเนินการ generate random numbers เมื่อข้อมูลถูกลบสำเร็จ
          await generateRandomNumbers(context);
        } else {
          dl.log('Failed to delete lottos');
        }
      } catch (e) {
        dl.log('Error deleting lottos: $e');
      }
    }
  }

  Future<void> generateRandomNumbers(BuildContext context) async {
    final random = Random();
    List<String> randomNumbers = [];
    for (int i = 0; i <= 100; i++) {
      String randomNumber = '';
      for (int j = 0; j < 6; j++) {
        randomNumber += random.nextInt(10).toString();
      }
      randomNumbers.add(randomNumber);
    }
    // แสดง Dialog ที่มี Progress Bar
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด dialog โดยผู้ใช้
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(width: 15),
                  Text('กรุณารอสักครู่'),
                ],
              ),
            );
          },
        );
      },
    );
    // ส่งหมายเลขทีละตัวและอัปเดต progress ใน dialog
    for (var number in randomNumbers) {
      var data = InsertLotto(lottoNumber: number);
      try {
        var response = await http.post(
          Uri.parse('https://node-api-lotto.vercel.app/lotto/createLotto'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(data.toJson()),
        );

        if (response.statusCode == 201) {
          // เรียก setState เพื่ออัปเดต UI ของ dialog
          setState(() {});
        } else {
          // จัดการกรณีที่ส่งไม่สำเร็จ
        }
      } catch (e) {
        // จัดการกรณีที่เกิดข้อผิดพลาด
      }
    }
    // ปิด Dialog หลังจากทำงานเสร็จ
    Navigator.of(context).pop();
  }

  // กลับไปที่หน้า LoginPage
  loginPage(BuildContext context) {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void randomlotto() {}
}

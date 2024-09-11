import 'package:flutter/material.dart';
import 'package:lottoproject/model/req/lottoNumber.dart';
import 'package:lottoproject/model/res/lottoNumberRes.dart';
import 'dart:developer' as dv;
import 'dart:math' as mt; 
import 'package:lottoproject/pages/LoginPage.dart';
import 'package:http/http.dart' as http;
class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> prizeNumbers = List.filled(5, '000000'); // สร้างลิสต์สำหรับเก็บหมายเลขรางวัล
  bool areButtonsDisabled = false; // สถานะปุ่ม

  // สร้างเลขสุ่ม 6 หลัก
  // String generateRandomNumber() {
  //   Random random = Random();
  //   int randomNumber = random.nextInt(900000) + 1;
  //   return randomNumber.toString().padLeft(6, '0');
  // }

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
  String server = '';
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                  backgroundColor: areButtonsDisabled ? Colors.grey : Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  backgroundColor: areButtonsDisabled ? Colors.grey : Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'ออกผลรางวัลจากทั้งหมด',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: showResetDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
    // setState(() {
    //   for (int i = 0; i < prizeNumbers.length; i++) {
    //     prizeNumbers[i] = generateRandomNumber();
    //   }
    //   areButtonsDisabled = true;
    // });
  }

  // รีเซ็ตหมายเลขรางวัล
  void resetPrizes() {
    
    final numbers = generateUniqueSixDigitNumbers(20);
    for (var number in numbers) {
      String input = number.toString();
      var data = LottoNumberReq(lottoNumber:input);
      
      //
      http.post(Uri.parse('$server/lotto/createLotto'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: lottoNumberReqToJson(data),
      ).then((value) {
        LottoNumberRes response = lottoNumberResFromJson(value.body);
        dv.log('Message: ${response.message}');
      }).catchError((error) {
        dv.log(error);
      });
    }
    Navigator.of(context).pop();
  }

  // ยืนยันการรีเซ็ต
  void showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รีเซ็ตระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการรีเซ็ต?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ตกลง'),
              onPressed: resetPrizes,
              
            ),
          ],
        );
      },
    );
  }

  // กลับไปที่หน้า LoginPage
  loginPage(BuildContext context) {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  //camp is here
  List<int> generateUniqueSixDigitNumbers(int count) {
  if (count > 900000) {
    throw ArgumentError('Cannot generate more than 900,000 unique 6-digit numbers');
  }
  
  final random = mt.Random();
  final uniqueNumbers = <int>{};
  
  while (uniqueNumbers.length < count) {
    final number = 100000 + random.nextInt(900000);
    uniqueNumbers.add(number);
  }
  
  return uniqueNumbers.toList();
  }

  
}

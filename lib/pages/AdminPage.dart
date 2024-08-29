import 'package:flutter/material.dart';
import 'dart:math';
import 'package:lottoproject/pages/LoginPage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> prizeNumbers = List.filled(5, '000000'); // สร้างลิสต์สำหรับเก็บหมายเลขรางวัล
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
          ),
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: buildSpacedNumber(prizeNumbers[0]), // แสดงหมายเลขรางวัลที่ 1
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
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: buildSpacedNumber(prizeNumbers[1]), // แสดงหมายเลขรางวัลที่ 2
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
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: buildSpacedNumber(prizeNumbers[2]), // แสดงหมายเลขรางวัลที่ 3
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
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: buildSpacedNumber(prizeNumbers[3]), // แสดงหมายเลขรางวัลที่ 4
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
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: buildSpacedNumber(prizeNumbers[4]), // แสดงหมายเลขรางวัลที่ 5
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(), // ช่องว่างระหว่างรายการรางวัลและปุ่มด้านล่าง
            ElevatedButton(
              onPressed: areButtonsDisabled ? null : drawPrizes, // ปุ่มกดเพื่อออกผลรางวัลจากที่ขายไป
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
              onPressed: areButtonsDisabled ? null : drawPrizes, // ปุ่มกดเพื่อออกผลรางวัลจากทั้งหมด
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
              onPressed: showResetDialog, // ปุ่มรีเซ็ตระบบ
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
              onPressed: 
                 () => loginPage(context), 
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
    );
  }

  // ออกผลรางวัล
  void drawPrizes() {
    setState(() {
      for (int i = 0; i < prizeNumbers.length; i++) {
        prizeNumbers[i] = generateRandomNumber(); // สุ่มหมายเลขรางวัล
      }
      areButtonsDisabled = true; // ปิดการใช้งานปุ่มหลังจากกดแล้ว
    });
  }

  // รีเซ็ตหมายเลขรางวัล
  void resetPrizes() {
    setState(() {
      prizeNumbers = List.filled(5, '000000'); // รีเซ็ตหมายเลขรางวัลกลับเป็น 000000
      areButtonsDisabled = false; // เปิดการใช้งานปุ่มอีกครั้ง
    });
    Navigator.pop(context); // ปิด Dialog หลังจากรีเซ็ต
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
                Navigator.of(context).pop(); // ปิด Dialog ถ้ากด ยกเลิก
              },
            ),
            TextButton(
              child: const Text('ตกลง'),
              onPressed: resetPrizes, // รีเซ็ตระบบเมื่อกด ตกลง
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
}

// void main() {
//   runApp(const MaterialApp(
//     home: AdminPage(),
//   ));
// }

// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class Chacklottopage extends StatefulWidget {
  const Chacklottopage({super.key});

  @override
  _CheckLottoPageState createState() => _CheckLottoPageState();
}

class _CheckLottoPageState extends State<Chacklottopage> {
  List<String> prizeNumbers = List.filled(6, 'X'); // สถานะของหมายเลขรางวัลที่ 1
  List<String> userNumbers = List.filled(6, 'X'); // สถานะของหมายเลขที่ซื้อ

  // ฟังก์ชันสำหรับการอัปเดตหมายเลขรางวัล (จำลอง)
  void updatePrizeNumbers() {
    setState(() {
      prizeNumbers = ['1', '2', '3', '4', '5', '6']; // เปลี่ยนหมายเลขรางวัล
    });
  }

  // ฟังก์ชันสำหรับการอัปเดตหมายเลขที่ซื้อ (จำลอง)
  void updateUserNumbers() {
    setState(() {
      userNumbers = ['9', '8', '7', '6', '5', '4']; // เปลี่ยนหมายเลขที่ซื้อ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Lotto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Prizes Card
            Card(
              color: Colors.purple,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'รางวัลที่ 1',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: prizeNumbers.map((number) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            width: 32,
                            height: 48,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                number,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    PrizeRow('รางวัลที่ 2', 'x x x x x x'),
                    PrizeRow('รางวัลที่ 3', 'x x x x x x'),
                    PrizeRow('รางวัลที่ 4', 'x x x x x x'),
                    PrizeRow('รางวัลที่ 5', 'x x x x x x'),
                  ],
                ),
              ),
            ),
            const SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: userNumbers.map((number) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Container(
                                        width: 25,
                                        height: 41,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text(
                                            number,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  updateUserNumbers(); // อัปเดตหมายเลขที่ซื้อเมื่อกดปุ่ม
                                },
                                child: const Text(
                                  'รอผล',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // รางวัล 12345
  Widget PrizeRow(String title, String number) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

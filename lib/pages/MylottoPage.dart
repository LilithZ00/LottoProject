import 'package:flutter/material.dart';

class Mylottopage extends StatefulWidget {
  final idx;
  const Mylottopage({super.key, required this.idx});

  @override
  State<Mylottopage> createState() => _MylottopageState(); 
}

class _MylottopageState extends State<Mylottopage> {
  String selectedFilter = 'ทั้งหมด'; // ตัวแปรที่เก็บค่าสถานะการกรองผลลัพธ์ที่เลือก
  bool hasWinningNumber = true; // ตัวแปรสำหรับตรวจสอบว่ามีตัวเลขที่ถูกรางวัลหรือไม่

  final List<Map<String, dynamic>> lottoNumbers = [ // รายการตัวเลขล็อตเตอรี่ที่จะแสดงใน ListView
    {
      'numbers': '000000', 
      'status': 'ไม่ถูกรางวัล', 
      'statusColor': Colors.red, 
    },
    {
      'numbers': '000000',
      'status': 'ถูกรางวัล', 
      'statusColor': Colors.green, 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myLotto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row( 
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>( // สร้าง Dropdown เพื่อกรองผลลัพธ์ตามสถานะที่เลือก
                  value: selectedFilter, // กำหนดค่าที่เลือกปัจจุบัน
                  items: <String>['ทั้งหมด', 'รอผล', 'ไม่ถูกรางวัล', 'ถูกรางวัล']
                      .map((String value) { 
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value), // แสดงค่าของรายการที่เลือก
                    );
                  }).toList(),
                  onChanged: (String? newValue) { // ฟังก์ชันที่ทำงานเมื่อมีการเลือกค่าจาก Dropdown
                    setState(() {
                      selectedFilter = newValue!; // อัปเดตค่าที่เลือกใหม่
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16), 
            Expanded(
              child: ListView.builder( // สร้าง ListView แบบกำหนดจำนวนรายการตามข้อมูล
                itemCount: lottoNumbers.length, // กำหนดจำนวนรายการที่จะแสดงตามจำนวนข้อมูลใน lottoNumbers
                itemBuilder: (context, index) {
                  if (selectedFilter != 'ทั้งหมด' &&
                      selectedFilter != lottoNumbers[index]['status']) { 
                      // ตรวจสอบว่าค่าที่เลือกใน Dropdown ตรงกับสถานะของข้อมูลหรือไม่ ถ้าไม่ตรงให้คืนค่าเป็น Container ว่างๆ
                    return Container();
                  }

                  return Card( 
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                          Row(
                            children: List.generate(6, (i) { 
                              return Container(
                                width: 15, 
                                height: 31, 
                                margin: const EdgeInsets.symmetric(horizontal: 4.0), 
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    lottoNumbers[index]['numbers'][i], // แสดงหมายเลขล็อตเตอรี่แต่ละตัวในกล่อง
                                    style: const TextStyle(
                                      fontSize: 24, 
                                      fontWeight: FontWeight.bold, 
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Container(
                            width: 120, 
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: lottoNumbers[index]['statusColor'], 
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                lottoNumbers[index]['status'], // แสดงสถานะของหมายเลขล็อตเตอรี่
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold), 
                              ),
                            ),
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
}

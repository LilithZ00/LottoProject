// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dv;

class Chacklottopage extends StatefulWidget {
  final idx;
  const Chacklottopage({super.key, required this.idx});

  @override
  _CheckLottoPageState createState() => _CheckLottoPageState();
}

class _CheckLottoPageState extends State<Chacklottopage> {
  List<String> prizeNumbers = List.filled(6, 'X'); // สถานะของหมายเลขรางวัลที่ 1
  List<String> userNumbers = List.filled(6, 'X'); // สถานะของหมายเลขที่ซื้อ
  List<Map<String, dynamic>> lottoData = [];
  List<Map<String, dynamic>> resultData = [];

  String no2 = '';
  String no3 = '';
  String no4 = '';
  String no5 = '';

  // ฟังก์ชันสำหรับการอัปเดตหมายเลขรางวัล (จำลอง)
  late Future<void> loadLotto;
  late Future<void> loadResult;
  @override
  void initState() {
    super.initState();
    loadLotto = showmylotto();
    loadResult = showResult();
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
                      'รางวัลที่ 1 มูลค่า 100,000 บาท',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (resultData.isNotEmpty &&
                                  resultData[0]['result_number'] != null
                              ? resultData[0]['result_number']
                                  .toString()
                                  .split('')
                              : prizeNumbers)
                          .map((number) {
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
                    PrizeRow(
                        'รางวัลที่ 2',
                        resultData.isNotEmpty &&
                                resultData[1]['result_number'] != null
                            ? resultData[1]['result_number'].toString()
                            : 'x x x x x x',
                        '50,000 บาท'),
                    PrizeRow(
                        'รางวัลที่ 3',
                        resultData.isNotEmpty &&
                                resultData[2]['result_number'] != null
                            ? resultData[2]['result_number'].toString()
                            : 'x x x x x x',
                        '30,000 บาท'),
                    PrizeRow(
                        'รางวัลที่ 4',
                        resultData.isNotEmpty &&
                                resultData[3]['result_number'] != null
                            ? resultData[3]['result_number'].toString()
                            : 'x x x x x x',
                        '10,000 บาท'),
                    PrizeRow(
                        'รางวัลที่ 5',
                        resultData.isNotEmpty &&
                                resultData[4]['result_number'] != null
                            ? resultData[4]['result_number'].toString()
                            : 'x x x x x x',
                        '5,000 บาท'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: lottoData.length,
                itemBuilder: (context, index) {
                  var lottoItem = lottoData[index];
                  String matchedPrizeCategory = '';
                  int matchedPrizeAmount = 0;

                  // Check if resultData is not empty and contains the lotto number
                  if (resultData.isNotEmpty) {
                    // Iterate over resultData to find if the lotto number matches any prize
                    for (int i = 0; i < resultData.length; i++) {
                      if (resultData[i]['result_number'] ==
                          lottoItem['lotto_number']) {
                        switch (i) {
                          case 0:
                            matchedPrizeCategory = 'รางวัลที่ 1';
                            matchedPrizeAmount = 100000;
                            break;
                          case 1:
                            matchedPrizeCategory = 'รางวัลที่ 2';
                            matchedPrizeAmount = 50000;
                            break;
                          case 2:
                            matchedPrizeCategory = 'รางวัลที่ 3';
                            matchedPrizeAmount = 30000;
                            break;
                          case 3:
                            matchedPrizeCategory = 'รางวัลที่ 4';
                            matchedPrizeAmount = 10000;
                            break;
                          case 4:
                            matchedPrizeCategory = 'รางวัลที่ 5';
                            matchedPrizeAmount = 5000;
                            break;
                          default:
                            matchedPrizeCategory = 'ไม่ระบุ';
                            matchedPrizeAmount = 0;
                        }
                      }
                    }
                  }

                  bool hasMatchingResult = matchedPrizeCategory.isNotEmpty;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              lottoItem['lotto_number'] ?? 'No Number',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: hasMatchingResult
                                ? () async {
                                    // Log the matched prize category and amount
                                    dv.log(
                                        'ถูกรางวัล: $matchedPrizeCategory จำนวนเงิน: $matchedPrizeAmount');

                                    // Send POST request to the API to add money
                                    var response = await http.post(
                                      Uri.parse(
                                          'https://node-api-lotto.vercel.app/wallet/add_money'),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: jsonEncode({
                                        "userId": widget
                                            .idx, // Assuming widget.idx is the user ID
                                        "amount": matchedPrizeAmount
                                      }),
                                    );

                                    var responseBody =
                                        json.decode(response.body);
                                    dv.log(
                                        'response:' + responseBody['message']);
                                    if (response.statusCode == 200 ||
                                        response.statusCode == 201) {
                                      if (responseBody['message'] ==
                                          'Deposit successfully') {
                                        dv.log(
                                            'เพิ่มเงินสำเร็จ: ${response.body}');

                                        // แสดง popup ว่าถูกรางวัล
                                        showWinningDialog(
                                            context,
                                            matchedPrizeCategory,
                                            matchedPrizeAmount);

                                        // Call deleteLotto function after successful "ถูกรางวัล"
                                        await deleteLotto(
                                            lottoItem['lotto_id']);
                                      } else {
                                        dv.log(
                                            'ข้อผิดพลาดในการเพิ่มเงิน: ${response.body}');
                                      }
                                    } else {
                                      dv.log(
                                          'ข้อผิดพลาดในการเพิ่มเงิน: ${response.statusCode} ${response.body}');
                                    }
                                  }
                                : null,
                            // Disable button if not a winning number
                            // Disable button if not a winning number
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasMatchingResult
                                  ? Colors.green
                                  : Colors
                                      .grey, // Set green color for "ถูกรางวัล", grey otherwise
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical:
                                      12.0), // Adjust button padding if needed
                            ),
                            child: Text(
                              resultData.isEmpty
                                  ? 'รอออกรางวัล' // If results are not available yet
                                  : (hasMatchingResult
                                      ? 'ถูกรางวัลที่ $matchedPrizeCategory'
                                      : 'ไม่ถูกรางวัล'), // Show prize category and amount if a match, otherwise "ไม่ถูกรางวัล"
                              style: const TextStyle(
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // รางวัล 12345
  Widget PrizeRow(String title, String number, String prizeValue) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RichText(
            text: TextSpan(
              text: title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18, // Normal size for title
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' มูลค่า $prizeValue',
                  style: const TextStyle(
                    fontSize: 12, // Smaller size for the prize value
                    color: Colors.white70, // Adjust color if needed
                  ),
                ),
              ],
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

  Future<void> showmylotto() async {
    try {
      // Include the user ID (widget.idx) in the API call URL
      var response = await http.get(Uri.parse(
          'https://node-api-lotto.vercel.app/lotto/check/${widget.idx}'));

      // Print the raw response body for debugging
      dv.log('Response Body: ${response.body}');

      // Try to decode the response body
      var data = json.decode(response.body);

      if (data is List) {
        setState(() {
          lottoData = List<Map<String, dynamic>>.from(data);
          dv.log('Lotto Data Length: ${lottoData.length}');
        });
      } else {
        dv.log('Data is not a list');
      }
    } catch (e) {
      dv.log('Error fetching lotto data: $e');
    }
  }

  Future<void> showResult() async {
    try {
      // Include the user ID (widget.idx) in the API call URL
      var response = await http
          .get(Uri.parse('https://node-api-lotto.vercel.app/result/'));
      var data2 = json.decode(response.body);
      if (data2 is List) {
        setState(() {
          resultData = List<Map<String, dynamic>>.from(data2);
          dv.log('resultData_lenght:' + resultData.length.toString());
        });
      } else {
        print('Data is not a list');
      }
    } catch (e) {
      dv.log('Error fetching lotto data: $e');
    }
  }

  Future<void> deleteLotto(int lottoId) async {
    try {
      var response = await http.delete(
        Uri.parse('https://node-api-lotto.vercel.app/lotto/delete/$lottoId'),
      );
      if (response.statusCode == 200) {
        dv.log('ลบลอตเตอรี่สำเร็จ: $lottoId');
        // Optionally, you can refresh the lottoData after deletion
        await showmylotto();
      } else {
        dv.log('ลบลอตเตอรี่ล้มเหลว: ${response.body}');
      }
    } catch (e) {
      dv.log('เกิดข้อผิดพลาดในการลบลอตเตอรี่: $e');
    }
  }

  void showWinningDialog(
      BuildContext context, String prizeCategory, int prizeAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยินดีด้วย'),
          content: Text(
              'คุณถูกรางวัลที่ $prizeCategory\nคุณได้รับเงิน $prizeAmount บาท'),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dv;

import 'package:lottoproject/config/config.dart';

class Mylottopage extends StatefulWidget {
  final idx;
  const Mylottopage({super.key, required this.idx});

  @override
  State<Mylottopage> createState() => _MylottopageState();
}

class _MylottopageState extends State<Mylottopage> {
  List<Map<String, dynamic>> lottoData = [];
  List<String> resultNumbers = []; // Store result numbers here
  late Future<void> loadLotto;
  late Future<void> loadchekLotto;
  String server = '';
  String lottoStatus = ''; // Store checkmylotto result here
  String selectedFilter = 'ทั้งหมด'; // Default filter
  List<String> filterOptions = ['ทั้งหมด', 'ถูกรางวัล', 'ไม่ถูกรางวัล', 'รอผล'];

  @override
  void initState() {
    super.initState();
    loadLotto = showmylotto();
    loadchekLotto = checkmylotto(); // Initiate the function
    Config.getConfig().then((value) {
      setState(() {
        server = value['serverAPI'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myLotto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
          children: [
            // Dropdown Button
            DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
              items: filterOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            Text(
              lottoStatus.isNotEmpty ? lottoStatus : '',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),

            const SizedBox(height: 8),

            // Expanded to show the lotto numbers
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0), // Reduce padding
                itemCount: filteredLottoData().length, // Filtered data length
                itemBuilder: (context, index) {
                  var lottoItem = filteredLottoData()[index];

                  // Check if lotto_number matches any result_number
                  bool isWinner =
                      resultNumbers.contains(lottoItem['lotto_number']);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Expanded widget for lotto_number with increased width
                          Expanded(
                            child: Text(
                              lottoItem['lotto_number'] ?? 'No Number',
                              style: const TextStyle(
                                fontSize: 28, // Increase font size if needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Result status with reduced flex
                          Expanded(
                            flex: 1,
                            child: Text(
                              resultNumbers.isEmpty
                                  ? 'รอผล' // Display "Waiting for results" if no result numbers are available
                                  : isWinner
                                      ? 'ถูกรางวัล' // If winner
                                      : 'ไม่ถูกรางวัล', // If not winner
                              style: TextStyle(
                                fontSize: 14,
                                color: isWinner ? Colors.green : Colors.red,
                              ),
                              textAlign: TextAlign.right, // Align to right
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

  // Filter lottoData based on selected filter
  List<Map<String, dynamic>> filteredLottoData() {
    if (selectedFilter == 'ทั้งหมด') {
      return lottoData;
    } else if (selectedFilter == 'ถูกรางวัล') {
      return lottoData
          .where((lottoItem) =>
              resultNumbers.contains(lottoItem['lotto_number']))
          .toList();
    } else if (selectedFilter == 'ไม่ถูกรางวัล') {
      return lottoData
          .where((lottoItem) =>
              !resultNumbers.contains(lottoItem['lotto_number']) && resultNumbers.isNotEmpty)
          .toList();
    } else if (selectedFilter == 'รอผล') {
      return lottoData
          .where((lottoItem) => resultNumbers.isEmpty)
          .toList();
    }
    return lottoData;
  }

  Future<void> showmylotto() async {
    try {
      // Include the user ID (widget.idx) in the API call URL
      var response = await http.get(Uri.parse(
          'https://node-api-lotto.vercel.app/lotto/check/${widget.idx}'));
      var data = json.decode(response.body);
      dv.log('${widget.idx}');
      if (data is List) {
        setState(() {
          lottoData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Data is not a list');
      }
    } catch (e) {
      dv.log('Error fetching lotto data: $e');
    }
  }

  Future<void> checkmylotto() async {
    try {
      // Make the API call to check lotto results
      var response = await http
          .get(Uri.parse('https://node-api-lotto.vercel.app/result/'));
      var data = json.decode(response.body);

      // Extract result numbers from the API response and store them
      if (data.isNotEmpty) {
        dv.log(data.toString());
        setState(() {
          resultNumbers =
              List<String>.from(data.map((item) => item['result_number']));
          lottoStatus = ''; // Clear the status once we have results
        });
      } else {
        setState(() {
          lottoStatus = ''; // Waiting for the results
        });
      }
    } catch (e) {
      dv.log('Error fetching lotto data: $e');
      setState(() {
        lottoStatus = 'Error fetching results';
      });
    }
  }
}

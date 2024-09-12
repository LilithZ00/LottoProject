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
  late Future<void> loadLotto;
  String server = '';

  @override
  void initState() {
    super.initState();
    loadLotto = showmylotto();
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
          children: [
            const SizedBox(height: 16),
            const SizedBox(height: 16.0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: lottoData.length,
                itemBuilder: (context, index) {
                  var lottoItem = lottoData[index];
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
}

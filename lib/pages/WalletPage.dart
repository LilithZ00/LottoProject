import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:lottoproject/model/req/PostMoneyUserReponse.dart';
import 'package:lottoproject/model/res/GetUserReponse.dart';

class Walletpage extends StatefulWidget {
  final int idx;

  const Walletpage({
    super.key,
    required this.idx,
  });

  @override
  _WalletpageState createState() => _WalletpageState();
}

class _WalletpageState extends State<Walletpage> {
  late Future<void> loadData;
  String server = '';
  String url = '';
  List<GetUserReponse> user = [];
  int selectedAmount = 0; // Track the selected amount

  // Reference to the "Top-up" dialog
  late BuildContext topUpDialogContext;

  GetUserReponse getUserReponseFromJson(String str) {
    final jsonData = json.decode(str);
    return GetUserReponse.fromJson(jsonData);
  }

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();

    Config.getConfig().then(
      (value) {
        log(value['serverAPI']);
        setState(() {
          server = value['serverAPI'];
        });
      },
    );
  }

  Future<void> loadDataAsync() async {
    try {
      var config = await Config.getConfig();
      url = config['serverAPI'];

      log('$url/users/${widget.idx}');

      var res = await http.get(Uri.parse('$url/users/${widget.idx}'));
      if (res.statusCode == 200) {
        log('Response body: ${res.body}');
        GetUserReponse userResponse = getUserReponseFromJson(res.body);
        user = [userResponse];
        log('User list length: ${user.length}');
      } else {
        log('Error: ${res.statusCode} - ${res.reasonPhrase}');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      log('Error: $error');
    }
  }

  Future<void> topupAmount(int amount) async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("กำลังโหลด..."),
            ],
          ),
        );
      },
    );

    try {
      var response = await http.post(
        Uri.parse('$url/wallet/add_money'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(PostMoneyUserReponse(
          userId: widget.idx,
          amount: amount,
        ).toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Topup successful');

        // Close the loading dialog
        Navigator.of(context).pop();

        // Show the success dialog and refresh data after it is dismissed
        await _confirmTopup(context, refreshData);
      } else {
        log('Topup failed: ${response.statusCode}');
        throw Exception('Failed to top up');
      }
    } catch (error) {
      log('Error: $error');

      // Close the loading dialog
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmTopup(BuildContext context, Future<void> Function() onDismiss) {
    // Close the "Top-up" dialog if it's open
    Navigator.of(topUpDialogContext).pop();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("ชำระเงินสำเร็จ"),
            ],
          ),
        );
      },
    ).then((_) => onDismiss()); // Call the refreshData callback after the dialog is dismissed
  }

  Future<void> refreshData() async {
    await loadDataAsync();
    setState(() {});
  }

  void withdraw(BuildContext context) {
    // Implement withdraw functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyWallet'),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: ${snapshot.error}'),
            );
          }
          if (user.isEmpty) {
            return const Center(
              child: Text('ไม่มีข้อมูล'),
            );
          }

          var currentUser = user[0];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
                    color: const Color.fromARGB(255, 246, 243, 247),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wallet),
                              Padding(
                                padding: EdgeInsets.all(35),
                                child: Text(
                                  'ยอดคงเหลือ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 5, 5, 5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${currentUser.userWallet} บาท',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () => topup(context),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/5567/5567180.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'เติมเงิน',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () => withdraw(context),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/5024/5024665.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'ถอนเงิน',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
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
    );
  }

  void topup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Save the context of this dialog
        topUpDialogContext = context;
        
        return AlertDialog(
          title: const Text('เติมเงิน'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 106,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () => topupAmount(100),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Money_Flat_Icon.svg/2048px-Money_Flat_Icon.svg.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '100 บาท',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 106,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () => topupAmount(1000),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/7630/7630510.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '1,000 บาท',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 106,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () => topupAmount(10000),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://static.vecteezy.com/system/resources/previews/019/006/277/original/money-cash-icon-png.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '10,000 บาท',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 106,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () => topupAmount(100000),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/2764/2764747.png'),
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '100,000 บาท',
                                style: TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        child: const Text('ยกเลิก'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

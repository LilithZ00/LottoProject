// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dv;

import 'package:flutter/material.dart';
import 'package:lottoproject/config/config.dart';
import 'package:lottoproject/model/res/AllLottos.dart';
import 'package:lottoproject/pages/LoginPage.dart';
import 'package:lottoproject/pages/ChackLottoPage.dart';
import 'package:lottoproject/pages/MylottoPage.dart';
import 'package:lottoproject/pages/ProfilePage.dart';
import 'package:lottoproject/pages/WalletPage.dart';
import 'package:lottoproject/shared/app_Data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final int idx;

  const HomePage({super.key, required this.idx});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int walletBalance = 50; // ดึง api
  final int ticketPrice = 100;

  final TextEditingController _searchLottoNumber = TextEditingController();

  late Future<void> loadData;
  late Future<void> loadLotto;
  late Future<void> checkLottoData;

  bool isProcessing = false;

  String server = '';
  List<Map<String, dynamic>> lottoData = [];

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
    loadLotto = showlotto();
    checkLottoData = check(context);

    Config.getConfig().then((value) {
      setState(() {
        server = value['serverAPI'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showSignOutPopup(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(245, 239, 247, 1),
          title: Consumer<AppData>(
            builder: (context, appData, child) {
              if (appData.user.userId != widget.idx) {
                return Center(
                  child: Text('User data not available'),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => profile(context),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(appData.user.userImage),
                      backgroundColor: Colors.grey,
                      radius: 20,
                    ),
                  ),
                  const Text(
                    'LOTTO',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${appData.user.userWallet} บาท',
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: FutureBuilder(
                future: loadLotto,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'),
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchLottoNumber,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Search for your LUCKY number!',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                _searchLotto(_searchLottoNumber.text);
                              },
                            ),
                          ],
                        ),
                      ),
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
                                        lottoItem['lotto_number'] ??
                                            'No Number',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        var appData = Provider.of<AppData>(
                                            context,
                                            listen: false);
                                        int userId = appData.user.userId;
                                        int lottoId = lottoItem['lotto_id'];
                                        sure(context, userId, lottoId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'ซื้อ 100 บาท',
                                        style: TextStyle(color: Colors.white),
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
                  );
                },
              ),
            ),
            if (isProcessing)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    loadLotto = showlotto();
                  });
                },
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.confirmation_number, color: Colors.black),
                    Text(
                      'My Lotto',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                onPressed: () => mylotto(context),
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.black),
                    Text(
                      'ChackLotto',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                onPressed: () => chacklotto(context),
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.black),
                    Text(
                      'Wallet',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Walletpage(idx: widget.idx),
                    ),
                  );
                  if (result != true) {
                    setState(() {
                      updateUserWallet();
                    });
                  }
                },
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    Text(
                      'Signout',
                      style: TextStyle(
                        color: Color.fromARGB(255, 244, 67, 54),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                onPressed: () => suresingout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserWallet() async {
    try {
      // Assuming loadDataAsync is your method to load or refresh wallet data
      await loadDataAsync(); // Replace this with the actual method if it's different
    } catch (error) {
      log('Error updating wallet: $error' as num);
    }
  }

  Future<bool> showSignOutPopup(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "คุณต้องการออกจากระบบใช่หรือไม่",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green[400],
                      ),
                      child: const Text(
                        "ตกลง",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red[400],
                      ),
                      child: const Text(
                        "ยกเลิก",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void suresingout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "คุณต้องการออกจากระบบใช่หรือไม่",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> sure(BuildContext context, int userId, int lottoId) async {
    dv.log('userId:' + userId.toString());
    dv.log('lottoId:' + lottoId.toString());

    var appData = Provider.of<AppData>(context, listen: false);
    int userWallet = appData.user.userWallet;

    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "คุณต้องการจะซื้อใช่หรือไม่",
                style: TextStyle(fontSize: 19),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(userWallet >= 100);
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        isProcessing = true;
      });
      await purchaseLotto(userId, lottoId);
      appData.updateUserWallet(userWallet - 100);
      await showSuccess(context);

      setState(() {
        isProcessing = false;
        loadLotto = showlotto();
      });
    } else if (result == false) {
      showFailure(context);
    }
  }

  Future<void> showSuccess(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("ชำระเงินสำเร็จ"),
            ],
          ),
          actions: <Widget>[
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green[400],
              ),
              child: const Text(
                "ตกลง",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  loadLotto = showlotto();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _searchLotto(String query) {
    final filteredData = lottoData.where((lotto) {
      final lottoNumber = lotto['lotto_number'].toString();
      return lottoNumber.contains(query);
    }).toList();

    setState(() {
      lottoData = filteredData;
    });
  }

  void showFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text("ชำระเงินไม่สำเร็จ"),
              Text("ยอดเงินในบัญชีไม่เพียงพอ"),
            ],
          ),
        );
      },
    );
  }

  void login(BuildContext context) {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void walletpage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Walletpage(idx: widget.idx)),
    );
  }

  void mylotto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Mylottopage(idx: widget.idx)),
    );
  }

  void chacklotto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chacklottopage(idx: widget.idx)),
    );
  }

  void profile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profilepage(idx: widget.idx)),
    );
  }

  Future<void> loadDataAsync() async {
    await Provider.of<AppData>(context, listen: false)
        .fetchUserProfile(widget.idx);
  }

  Future<void> showlotto() async {
    try {
      var response = await http.get(
          Uri.parse('https://node-api-lotto.vercel.app/lotto/readyToSell'));
      var data = json.decode(response.body);

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

  Future<void> check(BuildContext context) async {
    try {
      var response = await http.get(
          Uri.parse('https://node-api-lotto.vercel.app/lotto/readyToSell'));
      dv.log(response.body);
    } catch (e) {
      dv.log('Error fetching data: $e');
    }
  }
}

Future<void> purchaseLotto(int userId, int lottoId) async {
  try {
    var response = await http.post(
      Uri.parse('https://node-api-lotto.vercel.app/lotto/buylotto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
        'lottoId': lottoId,
      }),
    );
  } catch (e) {
    dv.log('Error making purchase: $e');
  }
}

// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api, unused_local_variable

import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dv;

import 'package:flutter/material.dart';
import 'package:lottoproject/config/config.dart';
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
  final TextEditingController _searchLottoNumber = TextEditingController();
  //เก็บข้อมูลดั้งเดิม
  List<Map<String, dynamic>> allLottoData = [];

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
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chacklottopage(idx: widget.idx),
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
      await loadDataAsync();
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
    // dv.log('userId:' + userId.toString());
    // dv.log('lottoId:' + lottoId.toString());

    // Check if lotto results are already available
    bool resultsOut = await checkLottoResults();
    if (resultsOut) {
      // If results are out, show a message and prevent buying
      showLottoResultsOutMessage(context);
      return;
    }

    var appData = Provider.of<AppData>(context, listen: false);
    int userWallet = appData.user.userWallet;
    bool? confirmPurchase = await showDialog<bool>(
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

    if (confirmPurchase == true) {
      final url = Uri.parse('https://node-api-lotto.vercel.app/lotto/');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      if (response.statusCode == 200) {
        // แปลงข้อมูล JSON เป็น List ของ Map
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        // ตรวจสอบว่ามีลอตเตอรี่ที่ยังไม่ถูกซื้อหรือไม่
        bool hasUnpurchasedLotto = false;
        bool hasPurchasedLotto = false;
        var itemToPurchase; // ตัวแปรเก็บลอตเตอรี่ที่ต้องทำการซื้อ

        for (var item in data) {
          if(lottoId == item['lotto_id']){
            // dv.log('id:'+lottoId.toString());
            // dv.log('itemId:'+item['lotto_id'].toString());
            
          if (item['lotto_status'] == 'ถูกซื้อไปแล้ว') {
            dv.log(
                'gg: ${item['lotto_number']} ถูกซื้อไปแล้ว'); // แสดง log ว่ามีการซื้อไปแล้ว
            hasPurchasedLotto = true;
            break;
          } else {
            hasUnpurchasedLotto = true; // พบลอตเตอรี่ที่ยังไม่ถูกซื้อ
            itemToPurchase = item; // เก็บลอตเตอรี่ที่ต้องทำการซื้อ
            break;
          }
          }
        }

        if (hasUnpurchasedLotto) {
          // ตั้งค่าการประมวลผลเป็น true
          setState(() {
            isProcessing = true;
          });

          // ทำการซื้อ
          await purchaseLotto(
              userId, itemToPurchase['lotto_id']); // ทำการซื้อลอตเตอรี่ที่เลือก
          appData.updateUserWallet(userWallet - 100); // อัปเดตยอดเงินในกระเป๋า

          // แสดงผลลัพธ์ความสำเร็จ
          await showSuccess(context);

          // ตั้งค่าการประมวลผลเป็น false และโหลดข้อมูลลอตเตอรี่ใหม่
          setState(() {
            isProcessing = false;
            loadLotto = showlotto(); // โหลดข้อมูลลอตเตอรี่ใหม่
          });
        }else{
          // ไม่มีลอตเตอรี่ที่ยังไม่ถูกซื้อ
          dv.log('รายการนี้ถูกซื้อไปแล้ว');
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ข้อมูลlotto'),
                  content: Text('รายการนี้ถูกซื้อไปแล้ว'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('ตกลง'),
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิด Dialog
                        // รีเฟรชหน้าจอ
                        setState(() {
                          loadLotto = showlotto(); // โหลดข้อมูลลอตเตอรี่ใหม่
                        });
                      },
                    ),
                  ],
                );
              });
        }
      } else {
        dv.log('Error: ${response.statusCode}');
      }
    } else if (confirmPurchase == false) {
      showFailure(context);
    }
  }

  Future<bool> checkLottoResults() async {
    try {
      var response = await http
          .get(Uri.parse('https://node-api-lotto.vercel.app/result/'));
      // dv.log('Response status code: ${response.statusCode}');
      // dv.log('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // ตรวจสอบว่าข้อมูลไม่ว่างเปล่าและมีเนื้อหาที่ต้องการ
        var data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          return true; // ผลรางวัลออกแล้ว
        }
      }
    } catch (e) {
      dv.log('Error checking lotto results: $e');
    }
    return false; // ผลรางวัลยังไม่ออก
  }

  void showLottoResultsOutMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text("ผลรางวัลได้ออกแล้ว"),
              Text("ไม่สามารถซื้อได้อีกต่อไป"),
            ],
          ),
          actions: <Widget>[
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red[400],
              ),
              child: const Text(
                "ตกลง",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    final filteredData = allLottoData.where((lotto) {
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
          allLottoData = List<Map<String, dynamic>>.from(data);
          lottoData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        dv.log('Data is not a list');
      }
    } catch (e) {
      dv.log('Error fetching lotto data: $e');
    }
  }

  Future<void> check(BuildContext context) async {
    try {
      var response = await http.get(
          Uri.parse('https://node-api-lotto.vercel.app/lotto/readyToSell'));
      // dv.log(response.body);
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

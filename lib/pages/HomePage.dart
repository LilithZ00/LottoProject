import 'package:flutter/material.dart';
import 'package:lottoproject/pages/LoginPage.dart';
import 'package:lottoproject/pages/ChackLottoPage.dart';
import 'package:lottoproject/pages/MylottoPage.dart';
import 'package:lottoproject/pages/ProfilePage.dart';
import 'package:lottoproject/pages/WalletPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final int walletBalance = 50;
  final int ticketPrice = 100;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // การกดย้อนกลับ
      onWillPop: () async {
        bool shouldPop = await showSignOutPopup(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(245, 239, 247, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => profile(context),
                child: const CircleAvatar(
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
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: 10, // จำนวนเลขที่แสดง
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'X X X X X X',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              sure(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
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
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.home, color: Color.fromARGB(255, 123, 123, 123)),
                    Text('Home',
                        style: TextStyle(
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontSize: 10,
                        )),
                  ],
                ),
                onPressed: null,
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.confirmation_number, color: Colors.black),
                    Text('My Lotto',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 10,
                        )),
                  ],
                ),
                onPressed: () => mylotto(context),
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.black),
                    Text('ChackLotto',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 10,
                        )),
                  ],
                ),
                onPressed: () => chacklotto(context),
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.black),
                    Text('Wallet',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 10,
                        )),
                  ],
                ),
                onPressed: () => wallet(context),
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    Text('Singout',
                        style: TextStyle(
                          color: Color.fromARGB(255, 244, 67, 54),
                          fontSize: 10,
                        )),
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

  // จับการออกจากระบบโดยกดย้อนกลับ
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
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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

  // จับการออกจากระบบโดยกดปุ่ม
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
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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

  // แน่ใจ?
  void sure(BuildContext context) {
    showDialog(
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
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (walletBalance >= ticketPrice) {
                      showSuccess(context);
                    } else {
                      showFailure(context);
                    }
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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

  // สำเร็จ
  void showSuccess(BuildContext context) {
    showDialog(
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
    );
  }

  // ชำระเงินไม่สำเร็จ
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

  wallet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Walletpage()),
    );
  }

  mylotto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Mylottopage()),
    );
  }

  chacklotto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Chacklottopage()),
    );
  }
  
  profile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profilepage()),
    );
  }
}

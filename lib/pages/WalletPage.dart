import 'package:flutter/material.dart';

class Walletpage extends StatelessWidget {
  final int idx;

  const Walletpage({
    super.key, 
    required this.idx,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Index: $idx'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Card(
                color: Color.fromARGB(255, 246, 243, 247),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
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
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10000000', // Replace hardcoded value with wallet value
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
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
      ),
    );
  }

  void topup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เติมเงิน'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 106,
                              height: 100,
                              child: ElevatedButton(
                                onPressed: () => topupsure(context),
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
                                      '100 บาท',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
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
                                onPressed: () => topupsure(context),
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
                                      '1,000 บาท',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 106,
                              height: 100,
                              child: ElevatedButton(
                                onPressed: () => topupsure(context),
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
                                      '10,000 บาท',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
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
                                onPressed: () => topupsure(context),
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
                                      '100,000 บาท',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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

  void withdraw(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'กรุณาระบุตัวเลข',
              filled: true,
              fillColor: Color(0xFFF0ECF6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ถอนเงินสำเร็จ'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('ถอนเงิน'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        child: const Text('ยกเลิก'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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

  void topupsure(BuildContext context) {
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
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:flutter/material.dart';

class changeProfilepage extends StatefulWidget {
  const changeProfilepage({super.key});

  @override
  State<changeProfilepage> createState() => _changeProfilepagStateState();
}

class _changeProfilepagStateState extends State<changeProfilepage> {
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('changeProfile'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadData,
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

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height:
                        200, // กำหนดความสูงให้เท่ากับความกว้างเพื่อทำให้เป็นวงกลม
                    child: ClipOval(
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOevN26UVJ1eOIeCHmqAnskc56YuTg01tDZw&s',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Card(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // ตั้งค่าสีพื้นหลัง
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // ทำให้ขอบโค้งมน
                    ),
                    elevation: 4, // ความสูงของเงา
                    child: Container(
                      width: 350, // กำหนดความกว้าง
                      height: 320, // กำหนดความสูง
                      padding: EdgeInsets.all(16), // ระยะห่างด้านใน
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Username'),
                                  TextField(
                                      // controller: fullnameCtl,
                                      )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Phone'),
                                  TextField(
                                      // controller: fullnameCtl,
                                      )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('E-mail'),
                                  TextField(
                                      // controller: fullnameCtl,
                                      )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FilledButton(
                                      onPressed: () {
                                        // ใส่ฟังก์ชันเมื่อกดปุ่มตกลง
                                      },
                                      child: const Text('ตกลง'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        // ใส่ฟังก์ชันเมื่อกดปุ่มยกเลิก
                                      },
                                      child: const Text('ยกเลิก'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {}

  void update() async {}
}

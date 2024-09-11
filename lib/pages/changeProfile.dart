// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously, camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottoproject/config/config.dart';
import 'package:lottoproject/model/req/UpDateUser.dart';
import 'package:lottoproject/shared/app_Data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class changeProfilepage extends StatefulWidget {
  final idx;
  const changeProfilepage({super.key, required this.idx});

  @override
  State<changeProfilepage> createState() => _changeProfilepagStateState();
}

class _changeProfilepagStateState extends State<changeProfilepage> {
  late Future<void> loadData;
  late TextEditingController nameController;
  late TextEditingController imgController;
  String server = '';
  bool isLoading = false; // เพิ่มตัวแปรสถานะเพื่อเช็คว่ากำลังอัปเดตข้อมูล

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

  @override
  void dispose() {
    nameController.dispose();
    imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Profile'),
      ),
      body: isLoading // เช็คสถานะการโหลด
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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

                  // เรียกข้อมูลจาก Provider
                  final userData = Provider.of<AppData>(context, listen: false).user;

                  // กำหนดค่าที่จะโชว์ใน TextField
                  nameController = TextEditingController(text: userData!.userName);
                  imgController = TextEditingController(text: userData.userImage);

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200, // กำหนดความสูงให้เท่ากับความกว้างเพื่อทำให้เป็นวงกลม
                          child: ClipOval(
                            child: Image.network(
                              userData.userImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Card(
                          color: const Color.fromARGB(255, 255, 255, 255), // ตั้งค่าสีพื้นหลัง
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // ทำให้ขอบโค้งมน
                          ),
                          elevation: 4, // ความสูงของเงา
                          child: Container(
                            width: 350, // กำหนดความกว้าง
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
                                          controller: nameController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('image'),
                                        TextField(
                                          controller: imgController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FilledButton(
                                            onPressed: updateProfile,
                                            child: const Text('ตกลง'),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
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

  Future<void> loadDataAsync() async {
    await Provider.of<AppData>(context, listen: false).fetchUserProfile(widget.idx);
  }

  void updateProfile() async {
    setState(() {
      isLoading = true; // แสดง CircularProgressIndicator เมื่อเริ่มการอัปเดต
    });

    try {
      // ตรวจสอบว่าฟิลด์ไม่ว่างเปล่า
      if (nameController.text.isEmpty || imgController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('เกิดข้อผิดพลาด'),
              content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิดป๊อปอัป
                  },
                  child: Text('ตกลง'),
                ),
              ],
            );
          },
        );
        setState(() {
          isLoading = false; // ซ่อน CircularProgressIndicator หากข้อมูลไม่ครบถ้วน
        });
        return;
      }

      // เตรียมข้อมูลที่จะส่ง
      var data = UpDateUserId(
        name: nameController.text,
        image: imgController.text,
      );

      // ส่งคำขอ HTTP PUT ไปยังเซิร์ฟเวอร์
      final response = await http.put(
        Uri.parse('$server/profile/update/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: upDateUserIdToJson(data),
      );

      // ตรวจสอบสถานะการตอบกลับจากเซิร์ฟเวอร์
      if (response.statusCode == 200 || response.statusCode == 201) {
        // แสดงป๊อปอัปแจ้งเตือนสำเร็จ
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('อัพเดทสำเร็จ'),
              content: Text('ข้อมูลถูกอัพเดทเรียบร้อยแล้ว'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิดป๊อปอัป
                    Navigator.of(context).pop(true); // กลับไปหน้า Profile และส่งข้อมูลกลับ
                  },
                  child: Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        log('Error: ${response.statusCode}'); // บันทึกสถานะข้อผิดพลาด
        showErrorDialog('ไม่สามารถอัพเดทข้อมูลได้');
      }
    } catch (error) {
      log('Error: $error'); // บันทึกข้อผิดพลาด
      showErrorDialog('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์');
    } finally {
      setState(() {
        isLoading = false; // ซ่อน CircularProgressIndicator หลังจากเสร็จสิ้นการอัปเดต
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เกิดข้อผิดพลาด'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดป๊อปอัป
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}


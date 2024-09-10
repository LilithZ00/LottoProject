// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottoproject/shared/app_Data.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
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

            // เรียกข้อมูลจาก Provider
            final userData = Provider.of<AppData>(context, listen: false).user;

            // กำหนดค่าที่จะโชว์ใน TextField
            nameController = TextEditingController(text: userData.userName);
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
    // อัปเดตข้อมูลใหม่จาก TextField ไปยัง Provider
    // appData.updateUserProfile(
    //   widget.idx,
    //   nameController.text,
    //   phoneController.text,
    //   emailController.text,
    // );

    // กลับไปหน้าก่อนหน้า
    Navigator.pop(context);
  }
}

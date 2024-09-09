// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:lottoproject/pages/changeProfile.dart';
import 'package:lottoproject/shared/app_Data.dart';
import 'package:provider/provider.dart';

class Profilepage extends StatefulWidget {
  final idx;

  const Profilepage({super.key,required this.idx});

  @override
  State<Profilepage> createState() => _ProfilepagStateState();
}

class _ProfilepagStateState extends State<Profilepage> {
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
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Consumer<AppData>(
          builder: (context, appData, child) {
            if (appData.user.userId != widget.idx) {
              return Center(
                child: Text('User data not available'),
              );
            }

            return Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipOval(
                    child: Image.network(
                       appData.user.userImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4,
                  child: Container(
                    width: 350,
                    height: 320,
                    padding: EdgeInsets.all(16),
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
                                  controller: TextEditingController(text: appData.user.userName), // ใช้ข้อมูลจาก provider
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Phone'),
                                TextField(
                                  controller: TextEditingController(text: appData.user.userType), // ใช้ข้อมูลจาก provider
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('E-mail'),
                                TextField(
                                  controller: TextEditingController(text: appData.user.userEmail), // ใช้ข้อมูลจาก provider
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: FilledButton(
                                onPressed: update,
                                child: const Text('Update'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    // เรียกใช้ fetchUserProfile จาก Provider
    await Provider.of<AppData>(context, listen: false).fetchUserProfile(widget.idx);
  }

  void update() async {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => changeProfilepage()),
        );
  }
}

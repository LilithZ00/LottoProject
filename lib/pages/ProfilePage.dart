// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:lottoproject/pages/changeProfile.dart';
import 'package:lottoproject/shared/app_Data.dart';
import 'package:provider/provider.dart';

class Profilepage extends StatefulWidget {
  final idx;

  const Profilepage({super.key, required this.idx});

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
            if (appData.user!.userId != widget.idx) {
              return Center(
                child: Text('User data not available'),
              );
            }

            return Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipOval(
                      child: Image.network(
                        appData.user!.userImage,
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileField('Username', appData.user!.userName),
                          Divider(),
                          _buildProfileField('Email', appData.user!.userEmail),
                          Divider(),
                          _buildProfileField('Wallet', appData.user!.userWallet.toString()),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: FilledButton(
                                onPressed: () async {
                                  bool? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => changeProfilepage(idx: widget.idx),
                                    ),
                                  );
                                  if (result == true) {
                                    // รีเฟรชข้อมูล
                                    setState(() {
                                      loadData = loadDataAsync();
                                    });
                                  }
                                },
                                child: const Text('Update'),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    // เรียกใช้ fetchUserProfile จาก Provider
    await Provider.of<AppData>(context, listen: false)
        .fetchUserProfile(widget.idx);
  }

  void update() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => changeProfilepage(idx: widget.idx)),
    );
  }
}

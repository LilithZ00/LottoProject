import 'package:flutter/material.dart';
import 'package:lottoproject/shared/app_Data.dart';
import 'package:provider/provider.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  String email = '';
  @override
  void initState() {
    super.initState();
    email = context.read<AppData>().userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: Text(email),
    );
  }
}
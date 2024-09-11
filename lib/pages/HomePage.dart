import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottoproject/config/config.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  String url = '';

  void initState() {
    super.initState();
    Config.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text('Lotto'),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: FilledButton(
                    onPressed: () => getLottos(), child: const Text('ทั้งหมด')),
              )
            ])
          ],
        ),
      ),
    );
  }
  
  getLottos() async{
    // var res = await http.get(Uri.parse('$url/trips'));
    // log(res.body);
    // List<TripGetResponse> tripGetResponses = tripGetResponseFromJson(res.body);
    // log(tripGetResponses.length.toString());
  }
}

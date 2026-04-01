import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatafromApi extends StatefulWidget {
  const DatafromApi({super.key});

  @override
  State<DatafromApi> createState() => _DatafromApiState();
}

class _DatafromApiState extends State<DatafromApi> {
  String _m = "Message from API";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(_m),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                getMessageFromAPi();
              },
              child: Text("Get Data"),
            ),
          ],
        ),
      ),
    );
  }

  void getMessageFromAPi() async {
    String url = "https://dhakashoping.xyz/hello_api.php";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _m = response.body;
      });
    } else {
      setState(() {
        _m = "${response.statusCode}  ${response.reasonPhrase}";
      });
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DummyApiExample extends StatefulWidget {
  const DummyApiExample({super.key});

  @override
  State<DummyApiExample> createState() => _DummyApiExampleState();
}

class _DummyApiExampleState extends State<DummyApiExample> {

  List productList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dummy Products")),
      body: Column(
        children: [

          ElevatedButton(
            onPressed: fetchData,
            child: Text("Load Products"),
          ),

          Expanded(
            child: ListView(
              children: [

                // 🔥 for loop
                for (int i = 0; i < productList.length; i++)
                  Card(
                    child: ListTile(
                      leading: Image.network(
                        productList[i]["thumbnail"],
                        width: 50,
                        errorBuilder: (c, e, s) => Icon(Icons.image),
                      ),
                      title: Text(productList[i]["title"]),
                      subtitle: Text("Price: \$${productList[i]["price"]}"),
                    ),
                  )

              ],
            ),
          )

        ],
      ),
    );
  }

  void fetchData() async {

    String url = "https://dummyjson.com/products";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          productList = data["products"]; // 🔥 important
        });

      } else {
        print("Error: ${response.statusCode}");
      }

    } catch (e) {
      print("Error: $e");
    }
  }
}
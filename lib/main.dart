import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<String>? randomNumber;

  Future<String> getData() async {
    final url = Uri.parse(
        'https://www.random.org/integers/?num=1&min=1&max=100&col=1&base=10&format=plain');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        
        return response.body.trim();
      } else {
        throw Exception('Failed to load random number');
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  void initState() {
    super.initState();
    randomNumber = getData();  
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: FutureBuilder(
          future: randomNumber,
          builder: (context, snapshot) {
            
            switch(snapshot.connectionState)
            {
              // case ConnectionState.active:
              //   return CircularProgressIndicator();
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.none:
                return Text("No Data");
              case ConnectionState.done:
                if(snapshot.hasData)
                {
                  return Text("${snapshot.data}");
                }
              default:
                return CircularProgressIndicator();


            }


            if (snapshot.hasData) {
              return Text("${snapshot.data}");
            }

            return Text("Waiting");
          },
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              randomNumber = getData();
            });
          },
          child: Icon(Icons.refresh_outlined),
        ),
      ),
    );
  }
}

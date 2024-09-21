import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> getCSGOPlayerCount() async {
  final apiKey = '********************************'; // 32 haneli apikeyiniz
  final appId = '730'; // game app id (example cs2 = 730)
  final apiUrl =
      'https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1/?appid=$appId&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['response'] != null &&
          jsonResponse['response']['player_count'] != null) {
        return jsonResponse['response']['player_count'];
      } else {
        print('Invalid JSON structure: $jsonResponse');
        return 0;
      }
    } else {
      throw Exception(
          'Failed to load player count. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _playerCount = 0;

  void _updatePlayerCount() async {
    try {
      int count = await getCSGOPlayerCount();
      setState(() {
        _playerCount = count;
      });
    } catch (e) {
      print('Error updating player count: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _updatePlayerCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CS:GO Player Count'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current CS:GO Player Count:',
            ),
            Text(
              '$_playerCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePlayerCount,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

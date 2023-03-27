import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter EDT iutInfo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
        ),
      ),
      home: const MyHomePage(title: 'Flutter EDT iutInfo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _rooms = [];
  List<bool> _isCheckedList = [];

  @override
  void initState() {
    _fetchRooms();

    super.initState();
  }

  void _handleRefresh() {
    List<String> checkedRooms = [];
    for (int i = 0; i < _isCheckedList.length; i++) {
      if (_isCheckedList[i]) {
        checkedRooms.add(_rooms[i]);
      }
    }
    print(checkedRooms);
  }

  void _handleCheckboxValueChanged(int index, bool value) {
    setState(() {
      _isCheckedList[index] = value;
    });
  }

  Future<void> _fetchRooms() async {
    final url = Uri.parse(
        "https://dptinfo.iutmetz.univ-lorraine.fr/applis/flutter_api_s1/api/rooms/findAllMachine.php");

    final response = await http.get(Uri.parse(
        "https://dptinfo.iutmetz.univ-lorraine.fr/applis/flutter_api_s1/api/rooms/findAllMachine.php"));

    setState(() {
      _rooms = [];
      final data = json.decode(response.body);
      data.forEach((donnee) {
        _rooms.add(donnee["nom"]);
        _isCheckedList.add(false);
      });
    });
  }

  Widget _buildRoomsCheckboxs(List<String> listOfRooms) {
    return Wrap(
      spacing: 10.0, // espace entre chaque case à cocher
      runSpacing: 10.0, // espace entre chaque ligne
      children: listOfRooms.asMap().entries.map((entry) {
        final index = entry.key;
        final room = entry.value;
        return _buildCheckboxWithRoom(index, room);
      }).toList(),
    );
  }

  CheckboxListTile _buildCheckboxWithRoom(int index, String room) {
    return CheckboxListTile(
      title: Text(room),
      value: _isCheckedList[index],
      onChanged: (value) {
        setState(() {
          _isCheckedList[index] = value!;
        });
      },
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _rooms.isEmpty
                ? const CircularProgressIndicator()
                : Container(child: _buildRoomsCheckboxs(_rooms)),
            ElevatedButton(
                onPressed: _handleRefresh,
                child:
                    Text("Actualiser", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ))
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _testData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ) */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

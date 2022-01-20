import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:working_date_case/const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сохранение данных',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyCounter(title: 'Сохранение данных', storage: CounterStorage()),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class MyCounter extends StatefulWidget {
  const MyCounter({Key? key, required this.title, required this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;


  @override
  _MyCounterState createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  int _counter_1 = 0;
  int _counter_2 = 0;


  @override
  void initState() {
    super.initState();
    _loadCounter();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter_2 = value;
      });
    });
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_1 = (prefs.getInt('counter') ?? 0);
    });
  }

  // сохранение и чтение данных
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_1 = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter_1);
    });
  }

  Future<File> _incrementCounter_2() {
    setState(() {
      _counter_2++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter_2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Example SharedPreferences',
              style: headerTextStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text(
                  'Counter 1',
                  style: primaryTextStyle,
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Нажми на кнопку Counter 1: ', style: primaryTextStyle,),
                Text('$_counter_1', style: headerTextStyle),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Example Read and write files',
              style: headerTextStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: _incrementCounter_2,
                child: const Text(
                  'Counter 2',
                  style: primaryTextStyle,
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Нажми на кнопку Counter 2: ', style: primaryTextStyle,),
                Text('$_counter_2', style: headerTextStyle,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



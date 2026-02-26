import 'package:flutter/material.dart';

class Lure {
  final String id;
  final String name;
  final String? brand;
  final double weight;
  final int? price;

  Lure({
    required this.id,
    required this.name,
    required this.weight,
    this.brand,
    this.price,
  });

  void printName() {
    print("ルアー名: $name, 重さ: $weight");
  }
}

class Fish {
  final String name;
  final double weight;
  final bool? isFresh;

  Fish({this.name = "fishbone", this.weight = 0.0, this.isFresh});

  void printName() {
    print("魚の名前: $name");
    if (isFresh != null) {
      print("新鮮かどうか: ${isFresh! ? "新鮮" : "古い"}");
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

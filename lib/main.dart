import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/lure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([LureSchema], directory: dir.path);

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(isar: isar));
  }
}

class MyHomePage extends StatefulWidget {
  final Isar isar;
  const MyHomePage({super.key, required this.isar});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Lure> _lures = [];

  @override
  void initState() {
    super.initState();
    _refreshLures();
  }

  Future<void> _refreshLures() async {
    final allLures = await widget.isar.lures.where().findAll();
    setState(() {
      _lures = allLures;
    });
  }

  Future<void> _addLure() async {
    final newLure = Lure()
      ..name = 'ステラ 2500'
      ..brand = 'シマノ'
      ..lastUsedAt = DateTime.now();

    await widget.isar.writeTxn(() async {
      await widget.isar.lures.put(newLure);
    });

    _refreshLures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ルアーマネージャー')),
      body: ListView.builder(
        itemCount: _lures.length,
        itemBuilder: (context, index) {
          final lure = _lures[index];
          return ListTile(title: Text(lure.name), subtitle: Text(lure.brand));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLure,
        child: const Icon(Icons.add),
      ),
    );
  }
}

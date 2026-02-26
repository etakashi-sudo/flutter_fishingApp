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
    String name = '';
    String brand = '';
    LureCategory selectedCategory = LureCategory.minnow;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('ルアーの登録'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'メーカー'),
                    onChanged: (value) => brand = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '製品名'),
                    onChanged: (value) => name = value,
                  ),

                  // spacer
                  const SizedBox(height: 16),

                  DropdownButton<LureCategory>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: LureCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedCategory = value);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (name.isNotEmpty && brand.isNotEmpty) {
                      final newLure = Lure()
                        ..name = name
                        ..brand = brand
                        ..category = selectedCategory
                        ..lastUsedAt = DateTime.now();

                      await widget.isar.writeTxn(() async {
                        await widget.isar.lures.put(newLure);
                      });

                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _refreshLures();
                    }
                  },
                  child: const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
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

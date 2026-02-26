import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/lure.dart';

void main() async {
  // 1. Flutterエンジンの初期化
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 端末内の保存場所を確保 (C++でいうディレクトリパスの取得)
  final dir = await getApplicationDocumentsDirectory();

  // 3. データベースをオープン (LureSchemaは自動生成されたファイルの中に定義されています)
  final isar = await Isar.open([LureSchema], directory: dir.path);

  // アプリ起動。isarインスタンスをコンストラクタで渡す
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
  // DBから取得したデータを保持するリスト
  List<Lure> _lures = [];

  @override
  void initState() {
    super.initState();
    _refreshLures(); // 起動時にデータを読み込む
  }

  // DBから全件取得して画面を更新する
  Future<void> _refreshLures() async {
    final allLures = await widget.isar.lures.where().findAll();
    setState(() {
      _lures = allLures;
    });
  }

  // 新しいルアーを1つ追加する
  Future<void> _addLure() async {
    final newLure = Lure()
      ..name = 'ステラ 2500'
      ..brand = 'シマノ'
      ..lastUsedAt = DateTime.now();

    // Isarの書き込みは必ず「writeTxn（トランザクション）」の中で行うルール
    await widget.isar.writeTxn(() async {
      await widget.isar.lures.put(newLure);
    });

    _refreshLures(); // 保存したらリストを再読み込み
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

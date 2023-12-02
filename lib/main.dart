import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_app/objectbox.g.dart';
import 'package:objectbox_app/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Store? store;
  Box<User>? userBox;
  List<User> users = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    store = await openStore();
    userBox = store?.box<User>();
    fetchUsers();
  }

  void fetchUsers() {
    users = userBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ObjectBox')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'ユーザー名'),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              final user = User(name: controller.text);
              userBox?.put(user);
              fetchUsers();
              controller.text = '';
            },
            child: const Text('ユーザーを追加する')),
        Column(
          children: users
              .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No.${e.id} ${e.name ?? '名無し'}'),
                      IconButton(
                        onPressed: () {
                          userBox?.remove(e.id);
                          fetchUsers();
                        },
                        icon: const Icon(Icons.delete, size: 20),
                      ),
                    ],
                  ))
              .toList(),
        )
      ]),
    );
  }
}

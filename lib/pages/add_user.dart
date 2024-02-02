import 'package:flutter/material.dart';
import 'package:flutter_sqlite/database/database.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _HomeState();
}

class _HomeState extends State<AddUser> {
  late DatabaseHelper handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    handler.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Add user"),
    );
  }
}

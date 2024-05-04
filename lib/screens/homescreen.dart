import 'package:cw2/screens/nodes.dart';
import 'package:cw2/screens/crud-db/password_page.dart';
import 'package:flutter/material.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cartoon War App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctxs) => const PasswordPage()));
              },
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(255, 255, 230, 0),
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 350),
        //color: Colors.amber,
        alignment: Alignment.bottomRight,
        child: const Nodes(),
      ),
    );
  }
}

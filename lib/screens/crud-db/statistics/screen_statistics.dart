import 'package:cw2/screens/crud-db/statistics/list_view.dart';
import 'package:cw2/screens/crud-db/statistics/view_resume.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [const ResumeView(), const ListaView()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadisticas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cached_rounded),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
    );
  }
}

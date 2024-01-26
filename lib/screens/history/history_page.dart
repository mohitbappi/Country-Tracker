import 'package:country_tracker/screens/history/history_by_country.dart';
import 'package:country_tracker/screens/history/history_by_date.dart';
import 'package:country_tracker/strings/index.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(Strings.history),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.date_range_outlined)),
            Tab(icon: Icon(Icons.numbers)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HistoryByDate(),
          HistoryByCountry(),
        ],
      ),
    );
  }
}

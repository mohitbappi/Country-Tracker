import 'dart:convert';

import 'package:country_tracker/models/history_model.dart';
import 'package:country_tracker/utils/app_storage_provider.dart';
import 'package:country_tracker/widgets/exo2_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryByDate extends StatefulWidget {
  const HistoryByDate({super.key});

  @override
  State<HistoryByDate> createState() => _HistoryByDateState();
}

class _HistoryByDateState extends State<HistoryByDate> {
  List<HistoryModel> _history = [];
  final _appStorageProvider = AppStorageProvider();

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  void _getHistory() async {
    final res = await _appStorageProvider.readHistory();
    List<dynamic> jsonData = jsonDecode(res);
    List<HistoryModel> historyFromJson = jsonData.map((item) => HistoryModel.fromJson(item)).toList();

    setState(() {
      _history = historyFromJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _history.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final history = _history[index];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Exo2Text(
                    text: DateFormat('DD MMM yyyy').format(DateTime.tryParse(history.date) ?? DateTime.now()),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Exo2Text(
                    text: DateFormat('hh:mm a').format(DateTime.tryParse(history.date) ?? DateTime.now()),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 160,
                child: Exo2Text(
                  text: history.address,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

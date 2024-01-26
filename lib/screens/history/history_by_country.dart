import 'dart:convert';

import 'package:country_tracker/models/country_count_model.dart';
import 'package:country_tracker/utils/app_storage_provider.dart';
import 'package:country_tracker/widgets/exo2_text.dart';
import 'package:flutter/material.dart';

class HistoryByCountry extends StatefulWidget {
  const HistoryByCountry({super.key});

  @override
  State<HistoryByCountry> createState() => _HistoryByCountryState();
}

class _HistoryByCountryState extends State<HistoryByCountry> {
  List<CountryCountModel> _countryCountHistory = [];
  final _appStorageProvider = AppStorageProvider();

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  void _getHistory() async {
    final res = await _appStorageProvider.readCountryCount();
    List<dynamic> jsonData = jsonDecode(res);
    List<CountryCountModel> historyFromJson = jsonData.map((item) => CountryCountModel.fromJson(item)).toList();

    setState(() {
      _countryCountHistory = historyFromJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _countryCountHistory.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final history = _countryCountHistory[index];

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
              Exo2Text(
                text: history.name,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              Exo2Text(
                text: history.count.toString(),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:resas_basic_app/city/annual_municipality_tax.dart';
import 'package:resas_basic_app/env.dart';

class CityDetailPage extends StatefulWidget {
  const CityDetailPage({super.key, required this.city});

  final String city;

  @override
  State<CityDetailPage> createState() => _CityDetailPageState();
}

class _CityDetailPageState extends State<CityDetailPage> {
  late Future<String> _muunicipalityTaxesFuture;

  @override
  void initState() {
    super.initState();
    const host = 'opendata.resas-portal.go.jp';
    const endpoint = "/api/v1/municipality/taxes/perYear";
    final headers = {
      'X-API-KEY': Env.resasApiKey,
    };
    final param = {"prefCode": "14", "cityCode": "14131"};
    _muunicipalityTaxesFuture = http
        .get(Uri.https(host, endpoint, param), headers: headers)
        .then((res) => res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city),
      ),
      body: FutureBuilder<String>(
          future: _muunicipalityTaxesFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final result = jsonDecode(snapshot.data!)["result"]
                    as Map<String, dynamic>;
                final data = result["data"] as List;

                final items = data.cast<Map<String, dynamic>>();
                final taxes =
                    items.map(AnnualMunicipalityTax.fromJson).toList();
                String formatTaxLabel(int value) {
                  final formatted = NumberFormat("#,###").format(value * 1000);
                  return "$formatted円";
                }
                return ListView.separated(
                    itemCount: taxes.length,
                    separatorBuilder: (contest, index) => const Divider(),
                    itemBuilder: (context, index) {
                      // final item = items[index];
                      final tax = taxes[index];
                      return ListTile(
                        title: Text("${tax.year}年"),
                        trailing: Text(
                          formatTaxLabel(tax.value),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    });
              // return Center(
              //   child: Text(items.toString()),
              // );
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:resas_basic_app/city/detail_page.dart';
import 'package:resas_basic_app/env.dart';

class CityListPage extends StatefulWidget {
  const CityListPage({super.key});

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  //late Future<void> _future;
  late Future<String> _citiesfuture;

  @override
  void initState() {
    super.initState();
    // _future = Future.delayed(const Duration(seconds: 3));
    const host = 'opendata.resas-portal.go.jp';
    const endpoint = "/api/v1/cities";
    final headers = {
      'X-API-KEY': Env.resasApiKey,
    };
    final parameters = {
      "prefCode": "14",
    };
    _citiesfuture = http
        .get(
          Uri.https(host, endpoint, parameters),
          headers: headers,
        )
        .then((res) => res.body);
    print(_citiesfuture);
  }

  @override
  Widget build(BuildContext context) {
    //component作成
    ListTile listTitleContainer(String title, String subtitle) {
      return ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.navigate_next),
        onTap: () {
          Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (context) => CityDetailPage(city: title)));
        },
      );
    }

    //ここまで
    return Scaffold(
      appBar: AppBar(
        title: const Text("市区町村一覧"),
      ),
      body: FutureBuilder<String>(
        future: _citiesfuture,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final json = jsonDecode(snapshot.data!)['result'] as List;
              final items = json.cast<Map<String, dynamic>>();

              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return listTitleContainer(
                        item['cityName'] as String, "政令指定都市");
                  }
                  // children: [
                  //   for (final city in cities) listTitleContainer(city, city)
                  // ],
                  );
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
          }
          //非同期処理が完了するまでインジケーターを表示
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

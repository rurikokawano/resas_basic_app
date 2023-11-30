import "package:flutter/material.dart";
import 'package:resas_basic_app/city/detail_page.dart';

class CityListPage extends StatefulWidget {
  const CityListPage({super.key});

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  late Future<void> _future;
  @override
  void initState() {
    super.initState();
    _future = Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    final cities = [
      "札幌市",
      "横浜市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市",
      "川崎市"
    ];
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
      body: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //非同期処置が完了(3秒後)したことを示す
            case ConnectionState.done:
              return ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  for (final city in cities) listTitleContainer(city, city)
                ],
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

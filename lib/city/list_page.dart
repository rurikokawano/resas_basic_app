import "package:flutter/material.dart";
import 'package:resas_basic_app/city/detail_page.dart';

class CityListPage extends StatelessWidget {
  const CityListPage({super.key});

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

      //市区町村情報はリスト表示してスクロールさせる
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [for (final city in cities) listTitleContainer(city, city)],
      ),
    );
  }
}

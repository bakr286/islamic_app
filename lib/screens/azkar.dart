import 'package:flutter/material.dart';

import '../data/azkar_data.dart';

class AzkarScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الأذكار الإسلامية')),
      body: ListView.builder(
        itemCount: azkar.length,
        itemBuilder: (context, index) {
          String title = azkar.keys.elementAt(index);
          List<String> azkarList = azkar[title]!;
          return ExpansionTile(
            title: Text(title),
            children: azkarList.map((zikr) => ListTile(title: Text(zikr))).toList(),
          );
        },
      ),
    );
  }
}
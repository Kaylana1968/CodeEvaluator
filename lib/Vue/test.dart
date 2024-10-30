import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/header.dart';
const List<String> category = [
  "Java",
  "Algorithmic",
  "Html/Css"
];

class TestPage extends StatefulWidget {
const TestPage({super.key, required this.title, required mongo.Db db});

final String title;

@override
State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String categoryValue = category.first;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: headerDisplay(context, widget.title, true),
        body: Center(
          child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Choise your category for the test"),
                DropdownButton(
                    isExpanded: true,
                    value: categoryValue,
                    items: category.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      categoryValue = value!;
                    })
                ),
                ElevatedButton(
                    child: const Text('Start'),
                    onPressed: () => (Navigator.pushNamed(context, '/evaluation', arguments: categoryValue))
                )
              ],
            )

          ,

    ),
    );


}
}
import 'package:flutter/material.dart';
import 'SmartStack/smartstack_component.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const List<String> _data = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmartStack(
        cardWidth: 390,
        cardHeight: 190,
        cardColor: Colors.red,
        indicatorColor: Colors.red,
        overlayColor: const Color(0x33000000),
        borderRadius: 20.0,
        data: _data,
        itemBuilder: (int index) {
          return Center(
            child: Text(
              _data[index],
              style: const TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
    );
  }
}

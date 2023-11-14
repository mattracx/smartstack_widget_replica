// Created by Matteo Raciti on 11/14/2023 +> https://github.com/mattracx/
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SmartStack(),
    );
  }
}

class SmartStack extends StatefulWidget {
  const SmartStack({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SmartStackState createState() {
    return _SmartStackState();
  }
}

// Define your constants for box width and height
const double cardWidth = 390;
const double cardHeight = 190;

class _SmartStackState extends State<SmartStack> {
  final PageController _controller = PageController(viewportFraction: 1.0);
  final List<String> _data = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    // Add more items as needed
  ];

  double _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });

    // Start the timer to automatically scroll the cards every 10 seconds
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (_currentPage < _data.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _controller.jumpToPage(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS Smart Stack Replica'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: cardWidth + 30,
            height: cardHeight + 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add any action needed when tapping the overlay
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity:
                                _currentPage.floor() != _currentPage ? 1 : 0,
                            duration: const Duration(milliseconds: 400),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                color: const Color(
                                    0x33000000), // Overlay Color & Opacity
                                width: cardWidth + 5,
                                height: cardHeight + 5,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: PageView.builder(
                              controller: _controller,
                              scrollDirection: Axis.vertical,
                              itemCount: _data.length,
                              itemBuilder: (context, index) {
                                double scale = 1;
                                double position = _currentPage - index;
                                if (position > 0) {
                                  scale =
                                      0.9 + 0.1 * (1 - position.abs() - 0.35);
                                } else if (position < 0) {
                                  scale =
                                      0.9 + 0.1 * (1 - position.abs() - 0.35);
                                }

                                return Center(
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Card(
                                      color: Colors.blue,
                                      elevation: 4.0,
                                      margin:
                                          const EdgeInsets.only(bottom: 0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: SizedBox(
                                        width: cardWidth,
                                        height: cardHeight,
                                        child: Center(
                                          child: Text(
                                            _data[index],
                                            style:
                                                const TextStyle(fontSize: 24.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: _currentPage.floor() != _currentPage ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < _data.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: i == _currentPage.round()
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

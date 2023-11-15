import 'package:flutter/material.dart';
import 'dart:async';

class SmartStack extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final Color cardColor;
  final Color indicatorColor;
  final Color overlayColor;
  final double borderRadius;
  final List<String> data;
  final Widget Function(int index) itemBuilder;

  const SmartStack({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.cardColor,
    required this.indicatorColor,
    required this.overlayColor,
    required this.borderRadius,
    required this.data,
    required this.itemBuilder,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SmartStackState createState() => _SmartStackState();
}

class _SmartStackState extends State<SmartStack> {
  late final PageController _controller;

  double _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0);
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });

    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (_currentPage < widget.data.length - 1) {
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.cardWidth + 30,
            height: widget.cardHeight + 5,
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
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              child: Container(
                                color: widget.overlayColor,
                                width: widget.cardWidth + 5,
                                height: widget.cardHeight + 5,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.cardWidth,
                            height: widget.cardHeight,
                            child: PageView.builder(
                              controller: _controller,
                              scrollDirection: Axis.vertical,
                              itemCount: widget.data.length,
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
                                      color: widget.cardColor,
                                      elevation: 4.0,
                                      margin:
                                          const EdgeInsets.only(bottom: 0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            widget.borderRadius),
                                      ),
                                      child: SizedBox(
                                        width: widget.cardWidth,
                                        height: widget.cardHeight,
                                        child: widget.itemBuilder(
                                            index), // Dynamic content
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
                      for (int i = 0; i < widget.data.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: i == _currentPage.round()
                                  ? widget.indicatorColor
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

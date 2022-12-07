import 'dart:math';

import 'package:bookio/data/local_data.dart';
import 'package:bookio/presentation/bookDetails/details_page.dart';
import 'package:bookio/shared/functions.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _controller = PageController();
  final _notifier = ValueNotifier(0.0);
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _notifier.value = _controller.page!;
    });
    _initTransitionAnimation();
  }

  @override
  void dispose() {
    _notifier.dispose();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 15.0,
            elevation: 0.0,
            title: const Text('Bookio',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_download_outlined,
                      color: Colors.grey)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.book_outlined, color: Colors.grey))
            ]),
        body: Stack(children: [_backWidget(), _frontWidget()]));
  }

  //back Image Widget
  Widget _backWidget() {
    return Image(
        image: const AssetImage('assets/background.png'),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width);
  }

  //main Widget Build
  Widget _frontWidget() {
    return ValueListenableBuilder<double>(
        valueListenable: _notifier,
        builder: (context, value, child) {
          return PageView.builder(
              controller: _controller,
              itemCount: books.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) =>
                  _itemBuilder(context, index, value));
        });
  }

  Widget _itemBuilder(context, index, value) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _bookWidget(context, index, value),
          _bookDetailWidget(index),
          const Spacer(),
          _bottomChipsWidget()
        ]));
  }

  Widget _bookWidget(context, int index, double value) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    //here we get the value scrolled from page to determine rotation
    double diff = index - value;
    //here we clamp value to prevent reverse rotation
    double clampVal = diff.clamp(0.0, 1.0);
    //here we used fraction power to scale the values of difference to be greater
    double rotation = 1.3 * pow(clampVal, 0.25);
    return Align(
        alignment: Alignment.center,
        child: InkWell(
            onTap: () => _opedDetailsPage(index),
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                      scale: _animation.value,
                      child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 40.0),
                          elevation: 10.0,
                          child: Transform(
                              transform: Matrix4.rotationY(rotation),
                              child: Image(
                                  image: AssetImage(books[index].image),
                                  fit: BoxFit.fill,
                                  height: h * 0.45,
                                  width: w * 0.65))));
                })));
  }

  //title and author Widgets wrapped with Hero Widget for Transition Animation
  Widget _bookDetailWidget(int index) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          heroWidget(
              'tag',
              Text(books[index].name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28))),
          const SizedBox(height: 5.08),
          heroWidget(
            'tag2',
            Text('By ${books[index].author}',
                style: const TextStyle(color: Colors.grey, fontSize: 20)),
          )
        ]);
  }

  //Bottom Widgets
  Widget _bottomChipsWidget() {
    return Row(children: [
      Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25)),
          child: const Text('Children\'s Fiction',
              style: TextStyle(color: Colors.black))),
      const SizedBox(width: 10),
      Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25)),
          child: const Text('General Fiction',
              style: TextStyle(color: Colors.black)))
    ]);
  }

  //functions
  _initTransitionAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation =
        Tween<double>(begin: 1.0, end: 1.7).animate(_animationController);
  }

  _onPageChanged(int page) {
    _controller.animateToPage(page,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
  }

  _opedDetailsPage(int index) {
    //start image scale animation
    _animationController.forward();

    //navigate to next page with fade animation
    Navigator.of(context)
        .push(PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            reverseTransitionDuration: const Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                  opacity: animation,
                  child: DetailsScreen(
                    book: books[index],
                  ));
            }))
        .then((value) => _animationController.reset()); //here we reset image scale again

  }
}

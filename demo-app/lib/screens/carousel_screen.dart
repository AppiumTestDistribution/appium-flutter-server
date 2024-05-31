import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselScreen extends StatelessWidget {
  final String title;

  CarouselScreen({required this.title, super.key});

  final List _colors = [
    Colors.amber,
    Colors.green,
    Colors.deepOrange,
    Colors.red
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: title),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Semantics(
          label: "carousel_slider_widget",
          explicitChildNodes: true,
          container: true,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            items: [1, 2, 3].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: _colors[i]),
                      child: Center(
                        child: Text(
                          '$i',
                          style: const TextStyle(fontSize: 24.0, color: Colors.white),
                        ),
                      ));
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

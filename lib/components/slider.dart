import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OffersSlider extends StatelessWidget {
  final List sliderData;

  OffersSlider({@required this.sliderData});

  @override
  Widget build(BuildContext context) {
    List<Widget> sliderImages = [];
    sliderData.forEach(
      (imagePath) {
        sliderImages.add(
          Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 1.0),
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
    return CarouselSlider(
      options: CarouselOptions(
        pauseAutoPlayOnTouch: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        aspectRatio: 2.0,
        viewportFraction: 0.9,
        height: MediaQuery.of(context).size.height * 0.25,
      ),
      items: sliderImages,
    );
  }
}

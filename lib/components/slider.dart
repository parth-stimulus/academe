import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OffersSlider extends StatelessWidget {
  final List sliderData;

  OffersSlider({@required this.sliderData});

  @override
  Widget build(BuildContext context) {
    List<Widget> sliderImages = [];
    sliderData.forEach((imagePath) {
      sliderImages.add(Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
//              decoration:
//              BoxDecoration(borderRadius: BorderRadius.circular()),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.symmetric(vertical: 1.0),
              child: GestureDetector(
//              onTap: imageOnTap,
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
      ));
    });
    return CarouselSlider(
//        enlargeCenterPage: true,
        pauseAutoPlayOnTouch: Duration(seconds: 10),
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        aspectRatio: 2.0,
        viewportFraction: 0.9,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.25,
        items: sliderImages
//        items: sliderData[].((i) {
//          return Builder(
//            builder: (BuildContext context) {
//              return Container(
//                decoration:
//                    BoxDecoration(borderRadius: BorderRadius.circular(2)),
//                width: MediaQuery.of(context).size.width,
//                margin: EdgeInsets.symmetric(horizontal: 4),
//                child: GestureDetector(
//                  onTap: () {
//                    print(i + ' Image Clicked');
//                  },
//                  child: Image.asset(
//                    i,
//                    fit: BoxFit.contain,
//                  ),
//                ),
//              );
//            },
//          );
//        }).toList(),
    );
  }
}

/*import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Sale_Carsousel extends StatefulWidget {
  @override
  _Sale_CarsouselState createState() => _Sale_CarsouselState();
}

class _Sale_CarsouselState extends State<Sale_Carsousel> {
  int _current = 0;
  int _active_index = 0;
  final controller = CarouselController();

  CarouselSlider carouselSlider;
  List imgList = ['images/phone.png', 'images/pharmacy.png', 'images/user.png'];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 30),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 14, right: 10),
                child: CarouselSlider.builder(
                  carouselController: controller,
                  options: CarouselOptions(
                      height: 150,
                      initialPage: 0,
                      viewportFraction: 1,
                      reverse: true,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      // enlargeStrategy: CenterPageEnlargeStrategy.height,
                      enableInfiniteScroll: false,
                      autoPlayInterval: Duration(seconds: 10),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _active_index = index;
                        });
                      }),
                  itemBuilder: (context, index, realindex) {
                    final imageurl = imgList[index];
                    return buildImage(imageurl, index);
                  },
                  itemCount: imgList.length,
                ),
              ),
            ],
          ),
          Positioned(
            left: -25,
            top: 50,
            child: RawMaterialButton(
              onPressed: previous,
              elevation: 2.0,
              fillColor: Colors.green,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              shape: CircleBorder(),
            ),
          ),
          Positioned(
            right: -25,
            top: 50,
            child: RawMaterialButton(
              onPressed: next,
              elevation: 2.0,
              fillColor: Colors.green,
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
                size: 20,
              ),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          color: Colors.grey,
          width: MediaQuery.of(context).size.width * 1,
          child: Image.asset(
            urlImage,
            fit: BoxFit.cover,
          ),
        ),
      );
  Widget buildIndicator() => Center(
        child: AnimatedSmoothIndicator(
          activeIndex: _active_index,
          count: imgList.length,
          onDotClicked: animatetoslide,
          effect: SlideEffect(
              dotHeight: 15,
              dotWidth: 15,
              activeDotColor: Colors.green,
              dotColor: Color(0xff87cd70)),
        ),
      );

  Widget buildBotton({bool stretch = false}) => Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
                left: 0,
                child: RaisedButton(
                  onPressed: previous,
                  child: Icon(Icons.arrow_back),
                )),
            SizedBox(
              width: 5,
            ),
            RaisedButton(
              onPressed: next,
              child: Icon(Icons.arrow_forward),
            )
          ],
        ),
      );

  void animatetoslide(int index) => controller.animateToPage(index);

  void previous() =>
      controller.previousPage(duration: Duration(microseconds: 500));

  void next() => controller.nextPage(duration: Duration(microseconds: 500));
}*/

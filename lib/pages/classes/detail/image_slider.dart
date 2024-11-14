import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/pages/classes/detail/main.dart';
import 'package:pims/_widgets/viewer.dart';

class ClassDetailImageSliderController extends ClassDetailController {
  RxInt currentIndex = 0.obs;
  setCurrenIndex(val) => currentIndex.value = val;
}

final CarouselSliderController _controller = CarouselSliderController();

class ClassDetailImageSlider extends StatelessWidget {
  ClassDetailImageSlider({super.key});

  final store = Get.put(ClassDetailImageSliderController());

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/sample/taekwondo.jpg',
      'assets/images/sample/taichi.jpg',
      'assets/images/sample/karate.jpg',
    ];
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady) {
        return Column(
          children: [
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 300,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      store.setCurrenIndex(index);
                    },
                  ),
                  items: imgList.map((item) {
                    return InkWell(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => ImageViewer(
                              image: item,
                            ),
                          );
                        },
                        child: Ink.image(
                          image: AssetImage(
                            item,
                          ),
                          fit: BoxFit.cover,
                        ));
                  }).toList(),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    constraints: BoxConstraints(minWidth: 50),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '${(store.currentIndex.value + 1).toString()} / ${imgList.length}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              constraints: BoxConstraints(maxHeight: 50),
              child: ListView(
                shrinkWrap: false,
                padding: EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                children: imgList.asMap().entries.map((e) {
                  final activeIndex = e.key == store.currentIndex.value;
                  return InkWell(
                    onTap: () {
                      _controller.animateToPage(
                        e.key,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                      store.setCurrenIndex(e.key);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          width: 2,
                          color: activeIndex
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                      width: 50,
                      child: Image.asset(
                        e.value,
                        fit: BoxFit.cover,
                        opacity: AlwaysStoppedAnimation(activeIndex ? 1 : 0.5),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        );
      }
      return Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Row(
              children: List.generate(
                3,
                (index) => Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}

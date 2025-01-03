import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/viewer.dart';

class ClassDetailImageSliderController extends GetxController {
  RxBool pageIsReady = true.obs;
  RxInt currentIndex = 0.obs;
  setCurrenIndex(val) => currentIndex.value = val;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = true;
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }
}

final CarouselSliderController _controller = CarouselSliderController();

class ClassDetailImageSlider extends StatelessWidget {
  ClassDetailImageSlider({super.key, this.images, required this.dataIsReady});
  final dynamic images;
  final bool dataIsReady;

  final store = Get.put(ClassDetailImageSliderController());

  @override
  Widget build(BuildContext context) {
    List<dynamic>? thisImages;
    if (images != null && images?.length > 0) {
      thisImages = images?.map((item) {
        return '$SERVER_URL/static/images/class/${item?['filename']}';
      })?.toList();
    }
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady && dataIsReady) {
        if (thisImages != null) {
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
                    items: thisImages.map((item) {
                      return InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (_) =>
                                  ImageViewer(image: item, type: 'link'),
                            );
                          },
                          child: Ink.image(
                            image: NetworkImage(item),
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
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${(store.currentIndex.value + 1).toString()} / ${thisImages.length}',
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
                  children: thisImages.asMap().entries.map((e) {
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
                                ? Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.5)
                                : Colors.transparent,
                          ),
                        ),
                        width: 50,
                        child: Image.network(
                          e.value,
                          fit: BoxFit.cover,
                          opacity:
                              AlwaysStoppedAnimation(activeIndex ? 1 : 0.5),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
        } else {
          return SizedBox(
            height: 250,
            child: Image.asset('assets/images/no-image.png', fit: BoxFit.cover),
          );
        }
      }
      return Column(
        children: [
          Container(
            height: 300,
            decoration:
                BoxDecoration(color: Colors.black.withValues(alpha: 0.05)),
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
                    color: Colors.black.withValues(alpha: 0.05),
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

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerPromoController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool pageIsReady = false.obs;
  RxList images = [].obs;

  setCurrenPage(val) {
    currentPage.value = val;
  }

  setPageIsReady(val) {
    pageIsReady.value = val;
  }

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = false;
      try {
        final api = await API().get('config/app/banner');
        final res = api.data?['data'] ?? [];
        images.value = res;
      } catch (e) {
        //
      } finally {
        pageIsReady.value = true;
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onInit();
    });
    super.refresh();
  }
}

class BannerPromo extends StatelessWidget {
  BannerPromo({super.key});

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final store = Get.put(BannerPromoController());
    double bannerHeight = (Get.width / 2) - 10;
    return Obx(() {
      final currentPage = store.currentPage.value;
      final pageIsReady = store.pageIsReady.value;
      final images = store.images.toList();
      return SizedBox(
        height: images.isNotEmpty ? bannerHeight : 0,
        child: pageIsReady
            ? Stack(
                children: images.isNotEmpty
                    ? [
                        CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: bannerHeight,
                            viewportFraction: 0.95,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.5,
                            // padEnds: false,
                            onPageChanged: (index, reason) {
                              store.setCurrenPage(index);
                            },
                          ),
                          items: images.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  // margin: EdgeInsets.symmetric(horizontal: 0.0),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(31, 125, 125, 125),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image(
                                    image: item?['image'] != null
                                        ? NetworkImage(item['image'])
                                        : AssetImage('assets/images/h2.jpg'),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    // child: Image.network(item,
                                    //     fit: BoxFit.cover, width: 1000)
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          alignment: Alignment.bottomCenter,
                          child: AnimatedSmoothIndicator(
                            // controller: controller,
                            activeIndex: currentPage,
                            count: images.length,
                            effect: WormEffect(
                              dotHeight: 5,
                              dotWidth: 5,
                              spacing: 3,
                              strokeWidth: 0,
                              dotColor: Color.fromARGB(150, 255, 255, 255),
                              activeDotColor: Theme.of(context).primaryColor,
                              // type: WormType.thin,
                            ),
                          ),
                        ),
                      ]
                    : [SizedBox.shrink()],
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
      );
    });
  }
}

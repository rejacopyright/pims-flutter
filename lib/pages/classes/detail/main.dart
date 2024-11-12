import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/pages/classes/detail/appbar.dart';
import 'package:pims/pages/classes/detail/bottom_nav.dart';
import 'package:pims/pages/classes/detail/description.dart';
import 'package:pims/pages/classes/detail/image_slider.dart';
import 'package:pims/pages/classes/detail/price.dart';

ScrollController classDetailScrollController = ScrollController();
GlobalKey classDetailTabKey = GlobalKey();

class ClassDetailController extends GetxController {
  RxBool pageIsReady = false.obs;

  @override
  void onReady() {
    pageIsReady.value = true;
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(const Duration(milliseconds: 200), () {
      onReady();
    });
    super.refresh();
  }
}

class ClassDetailPage extends StatelessWidget {
  const ClassDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Get.put(ClassDetailImageSliderController());
    final priceController = Get.put(ClassDetailPriceController());
    final descriptionController = Get.put(ClassDetailDescriptionController());
    log(Get.rootDelegate.parameters['type'].toString());
    final classType = Get.rootDelegate.parameters['type'];
    final thisClass =
        classesList.firstWhereOrNull((item) => item.name == classType);
    return Scaffold(
      bottomNavigationBar: SafeArea(child: ClassBottomNav()),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [ClassDetailAppBar()];
        },
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          displacement: 30,
          onRefresh: () async {
            imageController.refresh();
            priceController.refresh();
            descriptionController.refresh();
          },
          child: CustomScrollView(
            controller: classDetailScrollController,
            physics: AlwaysScrollableScrollPhysics(),
            scrollBehavior: MaterialScrollBehavior().copyWith(
              overscroll: false,
            ),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Column(
                    children: [
                      ClassDetailImageSlider(),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: ClassDetailPrice(),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: ClassDetailDescription(thisClass: thisClass),
                      ),
                    ],
                  );
                }, childCount: 1),
              ),
              // SliverAppBar(
              //   backgroundColor: Colors.white,
              //   shadowColor: Colors.black.withOpacity(0.25),
              //   elevation: 1,
              //   pinned: true,
              //   automaticallyImplyLeading: false,
              //   surfaceTintColor: Colors.transparent,
              //   centerTitle: false,
              //   toolbarHeight: 35,
              //   flexibleSpace: FlexibleSpaceBar(
              //     titlePadding: EdgeInsets.zero,
              //     centerTitle: false,
              //     title: ProductDetailTabs(
              //       key: productDetailTabKey,
              //     ),
              //   ),
              // ),
              // SliverList.builder(
              //   itemBuilder: (context, index) {
              //     return Text('Tab Content');
              //   },
              //   itemCount: 1,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

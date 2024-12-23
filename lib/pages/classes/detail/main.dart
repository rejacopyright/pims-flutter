// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_config/storage.dart';
import './appbar.dart';
import './bottom_nav.dart';
import './description.dart';
import './image_slider.dart';
import './price.dart';

ScrollController classDetailScrollController = ScrollController();
GlobalKey classDetailTabKey = GlobalKey();

fetchDetailClass(String? id) async {
// final queryParameters = {'page': 1, 'limit': 2};
  try {
    final api = await API().get('/class/open/$id/detail');
    final result = api.data;
    await storage.write('detailClass', result);
    return result;
  } catch (e) {
    return null;
  }
}

class ClassDetailController extends GetxController {
  RxBool pageIsReady = false.obs;
  RxBool dataIsReady = false.obs;
  final detailClass = Rxn<Map<String, dynamic>>(null);

  @override
  void onInit() {
    pageIsReady.value = true;
    Future.delayed(Duration(milliseconds: 300), () async {
      final id = Get.rootDelegate.parameters['id'];
      try {
        final res = await fetchDetailClass(id);
        detailClass.value = res;
      } finally {
        dataIsReady.value = true;
      }
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

class ClassDetailPage extends StatelessWidget {
  const ClassDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Get.put(ClassDetailImageSliderController());
    final priceController = Get.put(ClassDetailPriceController());
    final descriptionController = Get.put(ClassDetailDescriptionController());
    final thisController = Get.put(ClassDetailController());
    final box = GetStorage();
    final user = box.read('user');
    return Obx(() {
      final detail = thisController.detailClass.value;
      final thisClass = classesList.firstWhereOrNull(
          (item) => item.type == (detail?['service__id'] ?? 2));
      final gallery = detail?['class']?['class_gallery'];
      final dataIsReady = thisController.dataIsReady.value;
      dynamic images;
      if (gallery != null && gallery?.length > 0) {
        images = gallery;
      }
      String? start_date, start_time, end_time;
      int? duration;
      if (detail?['start_date'] != null) {
        start_date = DateFormat('EEEE, dd MMMM yyyy')
            .format(DateTime.parse(detail?['start_date']).toLocal());
        start_time = DateFormat('HH:mm')
            .format(DateTime.parse(detail?['start_date']).toLocal());
      }
      if (detail?['end_date'] != null) {
        end_time = DateFormat('HH:mm')
            .format(DateTime.parse(detail?['end_date']).toLocal());
      }
      if (detail?['start_date'] != null && detail?['end_date'] != null) {
        duration = DateTime.parse(detail?['end_date'])
            .difference(DateTime.parse(detail?['start_date']))
            .inMinutes;
      }
      final gender = detail?['class']?['gender'] ?? 3;
      final int quota = detail?['quota'] ?? 0;
      final int booked = detail?['transaction']?.length ?? 0;
      final isFull = booked >= quota;
      List userTrxIds = detail != null &&
              detail['transaction'] != null &&
              detail['transaction']?.length > 0
          ? detail['transaction']?.map((item) => item?['user']?['id']).toList()
          : [];
      final isBookedByMe = userTrxIds.contains(user?['id']);
      List transaction = detail?['transaction'] ?? [];
      return Scaffold(
        bottomNavigationBar: SafeArea(
            child: isFull
                ? ClassBottomNavFullQuota()
                : isBookedByMe
                    ? ClassBottomNavIsBookedByMe()
                    : ClassBottomNav()),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [ClassDetailAppBar()];
          },
          body: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 30,
            onRefresh: () async {
              thisController.onInit();
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
                        ClassDetailImageSlider(
                            images: images, dataIsReady: dataIsReady),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: ClassDetailPrice(
                            fee: detail?['fee'] ?? 0,
                            duration: duration ?? 0,
                            dataIsReady: dataIsReady,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: ClassDetailDescription(
                            thisClass: thisClass,
                            start_date: start_date,
                            start_time: start_time,
                            end_time: end_time,
                            trainer: detail?['trainer'],
                            gender: gender,
                            title: detail?['class']?['name'] ?? '-',
                            description:
                                detail?['class']?['description'] ?? '-',
                            dataIsReady: dataIsReady,
                            transaction: transaction,
                            quota: quota,
                          ),
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
    });
  }
}

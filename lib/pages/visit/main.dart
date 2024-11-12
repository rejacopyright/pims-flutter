import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/pages/visit/bottom_nav.dart';
import 'package:pims/pages/visit/header.dart';
import 'package:pims/pages/visit/select_times.dart';

class VisitAppController extends GetxController {
  RxBool pageIsReady = false.obs;
  final now = DateTime.now();
  final selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  final selectedTime = Rxn<DateTime>(null);

  void setSelectedDate(e) => selectedDate.value = e;
  void setSelectedTime(e) => selectedTime.value = e;

  @override
  void onReady() {
    pageIsReady.value = true;
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(const Duration(milliseconds: 100), () {
      onReady();
    });
    super.refresh();
  }
}

class VisitPage extends StatelessWidget {
  const VisitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final visitController = Get.put(VisitAppController());
    // final selectDaysController = Get.put(SelectDaysController());
    return Scaffold(
      // appBar: VisitAppBar(),
      bottomNavigationBar: SafeArea(child: VisitBottomNav()),
      body: Obx(
        () {
          final pageIsReady = visitController.pageIsReady.value;
          return NestedScrollView(
            // physics: const ClampingScrollPhysics(),
            // scrollBehavior:
            //     const MaterialScrollBehavior().copyWith(overscroll: false),
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                VisitHeader(pageIsReady: pageIsReady),
                // DaysWidget(),
              ];
            },
            body: RefreshIndicator(
              color: Theme.of(context).primaryColor,
              displacement: 10,
              onRefresh: () async {
                visitController.refresh();
                // selectDaysController.refresh();
              },
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  overscroll: false,
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return SelectTimes(pageIsReady: pageIsReady);
                      }, childCount: 1),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

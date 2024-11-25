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
    Future.delayed(Duration(milliseconds: 100), () {
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
    final selectTimesController = Get.put(SelectTimesController());
    return Scaffold(
      // appBar: VisitAppBar(),
      bottomNavigationBar: SafeArea(child: VisitBottomNav()),
      body: Obx(
        () {
          final pageIsReady = visitController.pageIsReady.value;
          return NestedScrollView(
            // physics: ClampingScrollPhysics(),
            // scrollBehavior:
            //     MaterialScrollBehavior().copyWith(overscroll: false),
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
                selectTimesController.refresh();
                // selectDaysController.refresh();
              },
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollBehavior: MaterialScrollBehavior().copyWith(
                  overscroll: false,
                ),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return SelectTimes();
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

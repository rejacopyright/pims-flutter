import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/config_controller.dart';
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
  void onInit() async {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      pageIsReady.value = true;
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 100), () {
      onInit();
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
    final configController = Get.put(ConfigController());
    return Scaffold(
      bottomNavigationBar: SafeArea(child: VisitBottomNav()),
      body: Obx(
        () {
          final pageIsReady = visitController.pageIsReady.value;
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 50,
            edgeOffset: 290,
            onRefresh: () async {
              configController.onInit();
              visitController.refresh();
              selectTimesController.refresh();
              // selectDaysController.refresh();
            },
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollBehavior: MaterialScrollBehavior().copyWith(
                overscroll: false,
              ),
              slivers: [
                VisitHeader(pageIsReady: pageIsReady),
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
          );
        },
      ),
    );
  }
}

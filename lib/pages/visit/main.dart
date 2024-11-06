import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/pages/visit/header.dart';
import 'package:pims/pages/visit/select_days.dart';

class VisitAppController extends GetxController {
  RxBool pageIsReady = false.obs;
  final now = DateTime.now();
  final selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;

  void setSelectedDate(e) {
    selectedDate.value = e;
  }

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 100), () {
      pageIsReady.value = true;
    });
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(const Duration(milliseconds: 400), () {
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
      appBar: VisitAppBar(),
      body: Obx(
        () {
          final pageIsReady = visitController.pageIsReady.value;
          return SafeArea(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 10)),
                SelectDays(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      displacement: 10,
                      onRefresh: () async {
                        visitController.refresh();
                        // selectDaysController.refresh();
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollBehavior: const MaterialScrollBehavior().copyWith(
                          overscroll: false,
                        ),
                        slivers: [
                          SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: pageIsReady
                                    ? Text('AAA')
                                    : Text('Loading...'),
                              );
                            }, childCount: 1),
                          ),
                        ],
                      ),
                    ),
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

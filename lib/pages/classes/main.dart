import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/pages/classes/select_days.dart';

import 'bottom_nav.dart';
import 'select_class.dart';
import 'studio/appbar.dart';

ScrollController classScrollController = ScrollController();

class ClassAppController extends GetxController {
  RxBool pageIsReady = false.obs;
  final now = DateTime.now();
  final selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  final selectedClass = Rxn<String>(null);

  void setSelectedDate(e) => selectedDate.value = e;
  void setSelectedClass(e) => selectedClass.value = e;

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

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classController = Get.put(ClassAppController());
    // final selectDaysController = Get.put(SelectDaysController());
    return Scaffold(
      bottomNavigationBar: SafeArea(child: ClassBottomNav()),
      body: Obx(
        () {
          final pageIsReady = classController.pageIsReady.value;
          return NestedScrollView(
            physics: const ClampingScrollPhysics(),
            scrollBehavior:
                const MaterialScrollBehavior().copyWith(overscroll: false),
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                StudioClassHeader(pageIsReady: pageIsReady),
                // DaysWidget(),
              ];
            },
            body: CustomScrollView(
              controller: classScrollController,
              physics: const NeverScrollableScrollPhysics(),
              scrollBehavior:
                  const MaterialScrollBehavior().copyWith(overscroll: false),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      displacement: 20,
                      onRefresh: () async {
                        classController.refresh();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 15,
                          right: 15,
                        ),
                        // child: SelectClass(pageIsReady: pageIsReady),
                        child: SelectClass(pageIsReady: pageIsReady),
                      ),
                    );
                  }, childCount: 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DaysWidget extends StatelessWidget {
  const DaysWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.25),
      elevation: 1,
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 110,
      collapsedHeight: 100,
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.35,
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
        // title: SelectDays(),
        title: SafeArea(
          child: Center(child: SelectDays()),
        ),
      ),
    );
  }
}
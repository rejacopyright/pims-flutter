import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/pages/member/main.dart';

import 'pages/active.dart';
import 'pages/cancel.dart';
import 'pages/done.dart';
import 'pages/unpaid.dart';

class TabList {
  String id;
  String label;
  IconData? icon;
  Widget child;
  TabList({
    required this.id,
    required this.label,
    this.icon,
    required this.child,
  });
}

class MemberTabsController extends MemberController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  final List<TabList> tabs = [
    TabList(
      id: 'unpaid',
      label: 'Belum Bayar',
      icon: Iconsax.empty_wallet_time4,
      child: UnpaidMemberPage(),
    ),
    TabList(
      id: 'active',
      label: 'Berjalan',
      icon: Iconsax.calendar_tick5,
      child: ActiveMemberPage(),
    ),
    TabList(
      id: 'done',
      label: 'Selesai',
      icon: Iconsax.location_tick5,
      child: DoneMemberPage(),
    ),
    TabList(
      id: 'cancel',
      label: 'Dibatalkan',
      icon: Iconsax.close_circle5,
      child: CancelMemberPage(),
    ),
  ];

  RxString currentID = ''.obs;
  setID(val) => currentID.value = val;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: tabs.length);
    // Future.delayed(Duration(microseconds: 200), () {
    //   controller.animateTo(2);
    // });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}

class MemberTabs extends StatelessWidget {
  const MemberTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(MemberTabsController());
    final Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        // physics: ClampingScrollPhysics(),
        tabAlignment: TabAlignment.start,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        unselectedLabelColor: primaryColor,
        labelColor: Colors.white,
        indicatorColor: primaryColor,
        padding: EdgeInsets.symmetric(vertical: 5),
        labelPadding: EdgeInsets.symmetric(horizontal: 5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: primaryColor,
        ),
        isScrollable: true,
        controller: store.controller,
        onTap: (e) async {
          store.setID(store.tabs[e].id);
          // Future.delayed(Duration(milliseconds: 100), () {
          //   // Scrollable.ensureVisible(context);
          //   RenderBox thisBox =
          //       memberTabKey.currentContext!.findRenderObject() as RenderBox;
          //   Offset position = thisBox.localToGlobal(Offset.zero);
          //   if (context.mounted &&
          //       position.dy > MediaQuery.of(context).size.height / 2) {
          //     memberScrollController.animateTo(
          //       position.dy - kToolbarHeight - 20,
          //       duration: Duration(milliseconds: 100),
          //       curve: Curves.linear,
          //     );
          //   }
          //   // memberScrollController.jumpTo(position.dy);
          // });
        },
        tabs: store.tabs.map((e) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              // border: Border.all(color: primaryColor, width: 1),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                e.icon != null
                    ? Icon(
                        e.icon,
                        size: 20,
                      )
                    : SizedBox.shrink(),
                Text(
                  e.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MemberTabContent extends StatelessWidget {
  const MemberTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.find<MemberTabsController>();
    final fullWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      late Widget currentTabContent = store.tabs
              .where((e) => e.id == store.currentID.value)
              .map((e) => e.child)
              .firstOrNull ??
          store.tabs.first.child;
      if (pageIsReady) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          // color: Colors.white,
          child: currentTabContent,
        );
      }
      return Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              width: fullWidth / 2,
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
            Container(
              height: 15,
              width: fullWidth / 3,
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
            Container(
              height: 50,
              width: fullWidth,
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
          ],
        ),
      );
    });
  }
}

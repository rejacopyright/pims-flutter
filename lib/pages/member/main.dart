import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';

import 'appbar.dart';
import 'tabs.dart';

ScrollController memberScrollController = ScrollController();
GlobalKey memberTabKey = GlobalKey();

class MemberController extends GetxController {
  RxBool pageIsReady = false.obs;

  @override
  void onReady() {
    pageIsReady.value = true;
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onReady();
    });
    super.refresh();
  }
}

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabx = Get.put(MemberTabsController());
    return Scaffold(
      appBar: MemberAppBar(),
      // bottomNavigationBar: NavbarWidget(name: '/member'),
      extendBody: true,
      floatingActionButton: QRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: tabx.controller,
        children: tabx.tabs.map((item) => item.child).toList(),
      ),
    );
  }
}

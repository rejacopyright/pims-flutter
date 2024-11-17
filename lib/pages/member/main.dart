import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_router/main.dart';

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
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MemberAppBar(),
      // bottomNavigationBar: NavbarWidget(name: '/member'),
      extendBody: true,
      floatingActionButton: SizedBox(
        // width: 65,
        // height: 65,
        child: FittedBox(
          child: FloatingActionButton.extended(
            icon: Icon(
              Iconsax.add,
              color: Colors.white,
              size: 25,
            ),
            label: Text(
              'Tambah Paket',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            isExtended: true,
            // elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: primaryColor,
            onPressed: () {
              Future.delayed(Duration(milliseconds: 200), () {
                Get.toNamed(
                  '$homeRoute${'/member/explore'}',
                );
              });
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: tabx.controller,
        children: tabx.tabs.map((item) => item.child).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/navbar.dart';
import 'package:pims/pages/order/appbar.dart';
import 'package:pims/pages/order/tabs.dart';

ScrollController orderScrollController = ScrollController();
GlobalKey orderTabKey = GlobalKey();

class OrderController extends GetxController {
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

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabx = Get.put(OrderTabsController());
    return Scaffold(
      appBar: OrderAppBar(),
      bottomNavigationBar: NavbarWidget(name: '/order'),
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

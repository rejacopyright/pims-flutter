import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/order_item_card.dart';

class DoneOrderController extends GetxController {
  RxBool isReady = false.obs;

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 300), () {
      isReady.value = true;
    });
    super.onReady();
  }

  @override
  void refresh() {
    isReady.value = false;
    Future.delayed(const Duration(milliseconds: 200), () {
      onReady();
    });
    super.refresh();
  }

  @override
  void onClose() {
    log('dispose');
    isReady.value = false;
    super.onClose();
  }
}

class DoneOrderPage extends StatelessWidget {
  const DoneOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(DoneOrderController());
    return Obx(() {
      final isReady = store.isReady.value;
      return RefreshIndicator(
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (ctx, index) =>
                isReady ? OrderItem() : OrderItemLoader(),
          ),
        ),
      );
    });
  }
}

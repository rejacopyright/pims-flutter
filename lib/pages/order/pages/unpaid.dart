import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnpaidController extends GetxController {
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

class UnpaidPage extends StatelessWidget {
  const UnpaidPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(UnpaidController());
    return Obx(() {
      final isReady = store.isReady.value;
      log(store.isReady.value.toString());
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: isReady
            ? ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: 70,
                itemBuilder: (ctx, index) =>
                    Text('Tab Lorem ipsum dolor sit amet ${index + 1}'),
              )
            : Text('Loading...'),
      );
    });
  }
}

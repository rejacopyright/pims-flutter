import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/member_item_card.dart';

class DoneMemberController extends GetxController {
  RxBool isReady = false.obs;

  @override
  void onReady() {
    Future.delayed(Duration(milliseconds: 300), () {
      log('done ready');
      isReady.value = true;
    });
    super.onReady();
  }

  @override
  void refresh() {
    isReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onReady();
    });
    super.refresh();
  }

  @override
  void onClose() {
    log('done dispose');
    isReady.value = false;
    super.onClose();
  }
}

class DoneMemberPage extends StatelessWidget {
  const DoneMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(DoneMemberController());
    final primaryColor = Theme.of(context).primaryColor;
    return Obx(() {
      final isReady = store.isReady.value;
      return RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        child: ListView.builder(
          padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
          itemCount: 3,
          itemBuilder: (ctx, index) => isReady
              ? MemberItem(params: {'status': 'done'})
              : MemberItemLoader(),
        ),
      );
    });
  }
}

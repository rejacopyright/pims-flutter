import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/member_item_card.dart';

class CancelMemberController extends GetxController {
  RxBool isReady = false.obs;

  @override
  void onReady() {
    Future.delayed(Duration(milliseconds: 300), () {
      log('cancel ready');
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
    log('cancel dispose');
    isReady.value = false;
    super.onClose();
  }
}

class CancelMemberPage extends StatelessWidget {
  const CancelMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(CancelMemberController());
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
          itemCount: 4,
          itemBuilder: (ctx, index) => isReady
              ? MemberItem(params: {'status': 'cancel'})
              : MemberItemLoader(),
        ),
      );
    });
  }
}

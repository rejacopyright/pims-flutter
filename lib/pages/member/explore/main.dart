import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'appbar.dart';
import 'item.dart';

class MemberExploreController extends GetxController {
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

class MemberExplorePage extends StatelessWidget {
  const MemberExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MemberExploreAppBar(),
      body: RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          // store.refresh();
        },
        child: ListView.builder(
          padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
          itemCount: 2,
          itemBuilder: (ctx, index) =>
              MemberExploreItem(params: {'status': 'active'}),
        ),
      ),
    );
  }
}

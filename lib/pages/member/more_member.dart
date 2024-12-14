import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/user_card.dart';

class MoreMemberController extends GetxController {
  RxBool pageIsReady = true.obs;

  setPageIsReady(val) {
    pageIsReady.value = val;
  }

  @override
  void onReady() {
    // pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      pageIsReady.value = true;
    });
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onReady();
    });
    super.refresh();
  }
}

class MoreMember extends StatelessWidget {
  MoreMember({super.key});

  final List<String> imgList = [
    'assets/avatar/6.png',
    'assets/avatar/5.png',
    'assets/avatar/6.png',
  ];

  @override
  Widget build(BuildContext context) {
    final topUserController = Get.put(MoreMemberController());
    return Obx(() {
      final pageIsReady = topUserController.pageIsReady.value;
      if (pageIsReady) {
        return Container(
          constraints: BoxConstraints(maxHeight: 140),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            children: imgList
                .map(
                  (e) => Container(
                    width: (MediaQuery.of(context).size.width * 0.75) - 15,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 3.5,
                      child: LinkWell(
                        to: '/services/visit',
                        child: StackedUserCard(avatar: e),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: List.generate(
            3,
            (index) => Container(
              width: (MediaQuery.of(context).size.width / 3) - 17.5,
              height: 125,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
          ),
        ),
      );
    });
  }
}

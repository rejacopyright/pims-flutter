import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgramSectionController extends GetxController {
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

class ProgramSection extends StatelessWidget {
  const ProgramSection({super.key});

  final int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ProgramSectionController());

    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady) {
        return NotificationListener<ScrollNotification>(
          onNotification: (e) {
            return true;
          },
          child: GridView.count(
            clipBehavior: Clip.antiAlias,
            childAspectRatio: 0.75,
            crossAxisCount: crossAxisCount,
            padding: EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // controller:
            //     ScrollController(keepScrollOffset: false),
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [],
          ),
        );
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: List.generate(
            2,
            (index) => Container(
              width: (MediaQuery.of(context).size.width / 2) - 20,
              height: 175,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
          ),
        ),
      );
    });
  }
}

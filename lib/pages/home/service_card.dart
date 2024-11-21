import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_router/main.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.label,
    this.icon,
    this.name,
    this.type = '',
  });

  final String label;
  final String? icon;
  final String? name;
  final String type;
  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        Get.rootDelegate
            .toNamed('$homeRoute${name ?? '/'}', parameters: {'type': type});
        // Get.rootDelegate.toNamed('$homeRoute${name ?? '/'}');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 75,
            padding: EdgeInsets.all(12.5),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: primary.withOpacity(0.175))),
            child: Image.asset(icon ?? 'logo.png'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.5),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceSectionController extends GetxController {
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

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ServiceSectionController());
    final Color primary = Theme.of(context).primaryColor;
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      final gridCount = 4;
      final gridSize = (MediaQuery.of(context).size.width / gridCount) - 30;
      if (pageIsReady) {
        return Container(
          color: primary.withOpacity(0),
          child: GridView.count(
            restorationId: 'home_menu',
            crossAxisCount: 3,
            padding: EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 0.9,
            shrinkWrap: true,
            // controller:
            //     ScrollController(keepScrollOffset: false),
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: servicesList
                .where((item) => item.home == true)
                .map(
                  (e) => ServiceCard(
                    label: e.label,
                    icon: e.icon,
                    name: e.name,
                    type: e.type,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            gridCount,
            (index) => Container(
              width: gridSize,
              height: gridSize,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      );
    });
  }
}

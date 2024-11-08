import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/pages/home/main.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.label, this.icon, this.name});

  final String label;
  final String? icon;
  final String? name;
  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        Get.rootDelegate.toNamed('$homeRoute${name ?? '/'}');
        // Get.toNamed('$homeRoute${name ?? '/'}');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 75,
            padding: const EdgeInsets.all(12.5),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: primary.withOpacity(0.175))),
            child: Image.asset(icon ?? 'logo.png'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceSectionController extends HomepageController {}

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ServiceSectionController());
    final Color primary = Theme.of(context).primaryColor;
    return Obx(() {
      final pageIsReady = store.loadingPage.value;
      final gridCount = 4;
      final gridSize = (MediaQuery.of(context).size.width / gridCount) - 30;
      if (pageIsReady) {
        return Container(
          color: primary.withOpacity(0),
          child: GridView.count(
            restorationId: 'home_menu',
            crossAxisCount: 3,
            padding:
                const EdgeInsets.only(top: 15, bottom: 5, left: 20, right: 20),
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
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
                  ),
                )
                .toList(),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            gridCount,
            (index) => Container(
              width: gridSize,
              height: gridSize,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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

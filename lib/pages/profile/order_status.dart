import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';
import 'main.dart';

class OrderStatus {
  final String label;
  final String? icon;
  final Map<String, String>? params;
  OrderStatus({required this.label, this.icon, this.params});
}

class ProfileOrderStatusController extends ProfileController {}

class ProfileOrderStatus extends StatelessWidget {
  const ProfileOrderStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;
    List<OrderStatus> servicesList = [
      OrderStatus(
        label: 'Belum Dibayar',
        icon: 'assets/icons/wallet.png',
        params: {'order_tab': 'unpaid'},
      ),
      OrderStatus(
        label: 'Aktif',
        icon: 'assets/icons/check.png',
        params: {'order_tab': 'active'},
      ),
      OrderStatus(
        label: 'Selesai',
        icon: 'assets/icons/calendar-tick.png',
        params: {'order_tab': 'done'},
      ),
      OrderStatus(
        label: 'Dibatalkan',
        icon: 'assets/icons/x-red.png',
        params: {'order_tab': 'cancel'},
      ),
    ];
    final profileOrderStatusController =
        Get.put(ProfileOrderStatusController());
    return Obx(() {
      final pageIsReady = profileOrderStatusController.pageIsReady.value;
      if (pageIsReady) {
        return Padding(
          padding: EdgeInsets.only(top: 10),
          child: GridView.count(
            restorationId: 'home_menu',
            crossAxisCount: 4,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            physics: NeverScrollableScrollPhysics(),
            // childAspectRatio: 0.9,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            children: servicesList
                .map(
                  (e) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(50),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: LinkWell(
                          to: '/order',
                          params: e.params,
                          child: Container(
                            width: 55,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.075),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: primary.withOpacity(0.5),
                              ),
                            ),
                            child: Image.asset(e.icon ?? 'logo.png'),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          e.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) => Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade200,
                  ),
                ),
                Container(
                  width: 50,
                  height: 10,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
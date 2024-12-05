import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/helper.dart';

class ClassDetailPriceController extends GetxController {
  RxBool pageIsReady = true.obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = true;
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }
}

class ClassDetailPrice extends StatelessWidget {
  ClassDetailPrice(
      {super.key, this.fee = 0, this.duration = 0, required this.dataIsReady});
  final int fee;
  final int duration;
  final bool dataIsReady;

  final store = Get.put(ClassDetailPriceController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady && dataIsReady) {
        return Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.black.withOpacity(0.5),
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black.withOpacity(0.25),
                width: 0.15,
              ),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      'Rp. ${currency.format(fee)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    // Text(
                    //   'Rp. 30.000',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 12,
                    //     color: Colors.black.withOpacity(0.25),
                    //     fontStyle: FontStyle.italic,
                    //     decoration: TextDecoration.lineThrough,
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     left: 5,
                    //     right: 5,
                    //     top: 1.5,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: Colors.red.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   child: Text(
                    //     '17%',
                    //     softWrap: false,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 12,
                    //       color: Colors.red,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Text(
                  '$duration menit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffaaaaaa),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(7.5),
        ),
      );
    });
  }
}

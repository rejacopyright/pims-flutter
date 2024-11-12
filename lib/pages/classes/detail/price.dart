import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/pages/classes/detail/main.dart';

class ClassDetailPriceController extends ClassDetailController {}

class ClassDetailPrice extends StatelessWidget {
  ClassDetailPrice({super.key});

  final store = Get.put(ClassDetailPriceController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady) {
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
                      'Rp. 25.000',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Rp. 30.000',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.25),
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '17%',
                        softWrap: false,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '90 menit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xffaaaaaa)),
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

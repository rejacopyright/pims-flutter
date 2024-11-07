import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/pages/visit/select_times.dart';

class VisitBottomNav extends StatelessWidget {
  VisitBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final selectTimesController = Get.put(SelectTimesController());
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 2.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Obx(
        () {
          final selectedTime = selectTimesController.selectedTime.value;
          final timeIsSelected = selectedTime != null;
          return Row(
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  child: BackWell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(
                            Iconsax.arrow_left,
                            color: Color(0xffaaaaaa),
                            size: 20,
                          ),
                          Text(
                            'Kembali',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffaaaaaa),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  color: timeIsSelected
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                  child: InkWell(
                    splashFactory: InkSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (timeIsSelected) {
                        showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            minHeight: 100,
                            maxHeight: Get.height / 2,
                          ),
                          context: context,
                          builder: (context) {
                            return Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              clipBehavior: Clip.antiAlias,
                              child: Ink(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 7.5,
                                      width: 75,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text('HAHAHA'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        'Booking',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/_widgets/payment/price_section.dart';
import 'package:pims/_widgets/payment/voucher_section.dart';
import 'package:pims/pages/visit/main.dart';
import 'package:pims/pages/visit/select_times.dart';

class VisitBottomNavController extends VisitAppController {}

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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: timeIsSelected
                    ? [
                        VoucherSection(),
                        TimeSection(
                          primaryColor: primaryColor,
                          selectedTime: selectedTime,
                        ),
                        PriceSection()
                      ]
                    : [SizedBox.shrink()],
              ),
              Row(
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
                                maxHeight: Get.height * 0.85,
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
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: PaymentCard(),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                offset: const Offset(0, 2.5),
                                                blurRadius: 7.5,
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            clipBehavior: Clip.antiAlias,
                                            color: primaryColor,
                                            child: BackWell(
                                              child: Container(
                                                height: 50,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
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
                            timeIsSelected ? 'Bayar' : 'Booking',
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
              ),
            ],
          );
        },
      ),
    );
  }
}

class TimeSection extends StatelessWidget {
  const TimeSection({
    super.key,
    required this.primaryColor,
    required this.selectedTime,
  });

  final Color primaryColor;
  final dynamic selectedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        // border: Border(
        //   bottom: BorderSide(width: 1, color: Color(0xffdddddd)),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 5,
            children: [
              Icon(
                Iconsax.calendar_1,
                size: 16,
                color: primaryColor,
              ),
              Text(
                selectedTime != null
                    ? DateFormat('EEEE, d MMMM y').format(selectedTime)
                    : '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(
                Iconsax.clock5,
                size: 14,
                color: primaryColor,
              ),
              Text(
                DateFormat('HH:mm').format(selectedTime),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

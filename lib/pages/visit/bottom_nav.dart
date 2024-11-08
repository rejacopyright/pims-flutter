import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';
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
                        VoucherContainer(primaryColor: primaryColor),
                        TimeContainer(
                          primaryColor: primaryColor,
                          selectedTime: selectedTime,
                        ),
                        PriceContainer()
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
                                            child: PaymentsCard(),
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

class PriceContainer extends StatelessWidget {
  const PriceContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final visitBottomNavController = Get.put(VisitBottomNavController());
    return Obx(() {
      final selectedVoucher = visitBottomNavController.selectedVoucher.value;
      final voucherIsSelected = selectedVoucher != null;
      return Container(
        padding: EdgeInsets.only(top: 10, bottom: 15),
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text('Total'),
            Wrap(
              spacing: 10,
              children: [
                Text(
                  'Rp.',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  currency.format(voucherIsSelected ? 45000 : 50000),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class TimeContainer extends StatelessWidget {
  const TimeContainer({
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

class VoucherContainer extends StatelessWidget {
  const VoucherContainer({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final visitBottomNavController = Get.put(VisitBottomNavController());
    return Obx(() {
      final selectedVoucher = visitBottomNavController.selectedVoucher.value;
      final voucherIsSelected = selectedVoucher != null;
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 5,
              children: [
                Icon(
                  Iconsax.discount_circle5,
                  size: 16,
                  color: primaryColor,
                ),
                Text(
                  'Voucher',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
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
                                  color: Colors.black.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Tersedia 3 Voucher',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ModalVoucher(primaryColor: primaryColor),
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
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 2.5),
                                      blurRadius: 7.5,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
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
                                        'Terapkan',
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
                },
                splashFactory: InkSplash.splashFactory,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 5,
                    children: [
                      Container(
                        child: voucherIsSelected
                            ? Text(
                                '-Rp. ${currency.format(5000)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.red),
                              )
                            : Text(
                                'Gunakan Voucher',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xffaaaaaa),
                                ),
                              ),
                      ),
                      Icon(
                        Iconsax.arrow_right_3,
                        size: 22,
                        color: Color(0xffaaaaaa),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ModalVoucher extends StatelessWidget {
  const ModalVoucher({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final visitBottomNavController = Get.put(VisitBottomNavController());
    final voucherData = List.generate(3, (index) => index.toString());
    return Obx(() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        children: voucherData.map((item) {
          final thisVoucherIsChecked =
              item == visitBottomNavController.selectedVoucher.value;
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              visitBottomNavController
                  .setSelectedVoucher(thisVoucherIsChecked ? null : item);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              child: CouponCard(
                border: BorderSide(
                  width: 1.5,
                  color:
                      thisVoucherIsChecked ? primaryColor : Color(0xffcccccc),
                ),
                height: 100,
                curveAxis: Axis.vertical,
                backgroundColor: Colors.white,
                firstChild: Container(
                  color: primaryColor.withOpacity(0.5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          primaryColor.withOpacity(1),
                          primaryColor.withOpacity(0.75),
                          primaryColor.withOpacity(0.25),
                          // primaryColor.withOpacity(0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.discount_shape5,
                            color: Colors.amber.shade400,
                            size: 30,
                          ),
                          Text(
                            'Diskon',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                secondChild: Container(
                  height: double.infinity,
                  color: thisVoucherIsChecked
                      ? primaryColor.withOpacity(0.1)
                      : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diskon',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Rp. ${currency.format(5000)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Wrap(
                                children: [
                                  Text(
                                    'Sisa : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '30 hari',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Iconsax.tick_circle5,
                          color: thisVoucherIsChecked
                              ? primaryColor
                              : Color(0xffdddddd),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class PaymentsCard extends StatelessWidget {
  const PaymentsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('HAHAHAd');
  }
}

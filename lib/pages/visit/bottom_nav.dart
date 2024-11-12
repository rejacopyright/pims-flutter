import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/_widgets/payment/payment_data.dart';
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
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -5),
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
                                  fontSize: 16,
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
                                maxHeight: Get.height * 0.9,
                              ),
                              context: context,
                              builder: (context) {
                                return BookingVisitPaymentCard();
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
                              fontSize: 16,
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

class BookingVisitPaymentCard extends StatelessWidget {
  const BookingVisitPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    return Obx(() {
      final selectedPayment = paymentController.selectedPayment.value;
      final paymentIsSelected = selectedPayment != null;
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: PaymentCard(),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 15,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      VisitFinalPrice(),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        clipBehavior: Clip.antiAlias,
                        color: primaryColor
                            .withOpacity(paymentIsSelected ? 1 : 0.5),
                        child: LinkWell(
                          to: '/order/detail',
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              'Booking',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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

class VisitFinalPrice extends StatelessWidget {
  const VisitFinalPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    return Obx(() {
      final selectedVoucher = paymentController.selectedVoucher.value;
      final selectedPayment = paymentController.selectedPayment.value;
      final voucherIsSelected = selectedVoucher != null;
      final paymentIsSelected = selectedPayment != null;
      final paymentDetail =
          paymentData.firstWhereOrNull((item) => item.id == selectedPayment);
      final discount = voucherIsSelected ? 5000 : 0;
      final fee = paymentIsSelected && paymentDetail!.fee != null
          ? paymentDetail.fee
          : 0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Table(
            // border: TableBorder.all(width: 1),
            defaultColumnWidth: IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Text(
                  'Visit :',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 20),
                Text(
                  'Rp. ${currency.format(50000)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.end,
                ),
              ]),
              TableRow(
                  children: voucherIsSelected
                      ? [
                          Text(
                            'Diskon :',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(width: 20),
                          Text(
                            '- Rp. ${currency.format(discount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ]
                      : List.generate(3, (index) => SizedBox.shrink())),
              TableRow(
                  children: paymentIsSelected
                      ? [
                          Text(
                            'Biaya layanan :',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Rp. ${currency.format(fee ?? 0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ]
                      : List.generate(3, (index) => SizedBox.shrink())),
              TableRow(children: [
                Text(
                  'Total :',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.end,
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Rp. ${currency.format((50000 - discount) + (fee ?? 0))}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ]),
            ],
          ),
        ],
      );
    });
  }
}

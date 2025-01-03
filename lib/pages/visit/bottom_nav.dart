// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_controller/config_controller.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/_widgets/payment/price_section.dart';
import 'package:pims/pages/visit/main.dart';

class BottomSheet {
  static void showPayment(context) {
    // Size size = MediaQuery.of(context).size;
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
}

class VisitBottomNavController extends GetxController {
  RxBool submitButtonIsLoading = false.obs;
  RxBool submitMemberButtonIsLoading = false.obs;
  setSubmitButtonIsLoading(e) => submitButtonIsLoading.value = e;
  setSubmitMemberButtonIsLoading(e) => submitMemberButtonIsLoading.value = e;
}

class VisitBottomNav extends StatelessWidget {
  VisitBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final visitController = Get.put(VisitAppController());
    final configController = Get.put(ConfigController());
    final state = Get.put(VisitBottomNavController());
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Obx(
        () {
          final selectedTime = visitController.selectedTime.value;
          final timeIsSelected = selectedTime != null;
          final isMember = configController.isMember.value;
          final visit_fee = configController.visit_fee.value;
          final submitMemberButtonIsLoading =
              state.submitMemberButtonIsLoading.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: timeIsSelected
                    ? [
                        // VoucherSection(),
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
                          : primaryColor.withValues(alpha: 0.5),
                      child: InkWell(
                        splashFactory: InkSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: isMember && visit_fee == 0
                            ? () {
                                showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                      child: ConfirmBooking(
                                        submitIsLoading:
                                            submitMemberButtonIsLoading,
                                        onSubmit: () async {
                                          if (!submitMemberButtonIsLoading) {
                                            state
                                                .setSubmitMemberButtonIsLoading(
                                                    true);
                                            await visitTransaction();
                                            state
                                                .setSubmitMemberButtonIsLoading(
                                                    false);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            : () {
                                if (timeIsSelected) {
                                  BottomSheet.showPayment(context);
                                }
                              },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: Text(
                            timeIsSelected
                                ? (isMember && visit_fee == 0
                                    ? 'Booking'
                                    : 'Bayar')
                                : 'Booking',
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

class ConfirmBooking extends StatelessWidget {
  const ConfirmBooking(
      {super.key, this.submitIsLoading = false, this.onSubmit});
  final bool submitIsLoading;
  final Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Icon(
              Iconsax.tick_circle,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              'Klik tombol booking untuk melanjutkan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xffdddddd))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.rootDelegate.popRoute(),
                    style: TextButton.styleFrom(
                      elevation: 0,
                      overlayColor: Colors.black.withValues(alpha: 0.25),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Color(0xffdddddd),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      onSubmit!();
                    },
                    style: TextButton.styleFrom(
                      elevation: 0,
                      overlayColor: Colors.black.withValues(alpha: 0.25),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      submitIsLoading ? 'Waiting...' : 'Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color:
                            submitIsLoading ? Color(0xffaaaaaa) : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
    final state = Get.put(VisitBottomNavController());
    return Obx(() {
      final selectedPayment = paymentController.selectedPayment.value;
      final paymentIsSelected = selectedPayment != null;
      final submitButtonIsLoading = state.submitButtonIsLoading.value;
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
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: PaymentCard(),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 15,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: Offset(0, -5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      VisitFinalPrice(),
                      ElevatedButton(
                        onPressed: !submitButtonIsLoading && paymentIsSelected
                            ? () async {
                                state.setSubmitButtonIsLoading(true);
                                await visitTransaction();
                                state.setSubmitButtonIsLoading(false);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          disabledBackgroundColor:
                              primaryColor.withValues(alpha: 0.25),
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          minimumSize: Size(double.infinity, 48),
                          shape: StadiumBorder(),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            submitButtonIsLoading ? 'Waiting...' : 'Booking',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
        color: primaryColor.withValues(alpha: 0.1),
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
    final configController = Get.put(ConfigController());
    return Obx(() {
      final isMember = configController.isMember.value;
      final selectedVoucher = paymentController.selectedVoucher.value;
      final selectedPayment = paymentController.selectedPayment.value;
      final voucherIsSelected = selectedVoucher != null;
      final paymentIsSelected = selectedPayment != null;
      final paymentData = paymentController.paymentData.value;
      final paymentDetail = paymentData
          ?.firstWhereOrNull((item) => item.name == selectedPayment?.name);
      final discount = voucherIsSelected ? selectedVoucher['value'] : 0;
      final fee = paymentIsSelected && paymentDetail!.fee != null && !isMember
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
                  'Rp. ${currency.format(configController.visit_fee.value)}',
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Rp. ${currency.format((configController.visit_fee.value - discount) + (fee ?? 0))}',
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

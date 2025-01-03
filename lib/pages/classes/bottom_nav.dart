import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/_widgets/payment/price_section.dart';
// import 'package:pims/_widgets/payment/voucher_section.dart';

class ClassBottomNav extends StatelessWidget {
  ClassBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              // VoucherSection(),
              PriceSection(),
            ],
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
                  color: primaryColor,
                  child: InkWell(
                    splashFactory: InkSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          minHeight: 100,
                          maxHeight: Get.height * 0.9,
                        ),
                        context: context,
                        builder: (context) {
                          return BookingClassButton();
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        'Booking',
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
      ),
    );
  }
}

class BookingClassButton extends StatelessWidget {
  const BookingClassButton({super.key});

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
                      ClassFinalPrice(),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        clipBehavior: Clip.antiAlias,
                        color: primaryColor.withValues(
                            alpha: paymentIsSelected ? 1 : 0.5),
                        child: InkWell(
                          splashFactory: InkSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (paymentIsSelected) {
                              Future.delayed(Duration(milliseconds: 200), () {
                                Get.back();
                              });
                            }
                          },
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

class ClassSection extends StatelessWidget {
  const ClassSection({
    super.key,
    required this.primaryColor,
    required this.selectedClass,
  });

  final Color primaryColor;
  final dynamic selectedClass;

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
                selectedClass != null
                    ? DateFormat('EEEE, d MMMM y').format(selectedClass)
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
                DateFormat('HH:mm').format(selectedClass),
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

class ClassFinalPrice extends StatelessWidget {
  const ClassFinalPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    return Obx(() {
      final selectedVoucher = paymentController.selectedVoucher.value;
      final selectedPayment = paymentController.selectedPayment.value;
      final voucherIsSelected = selectedVoucher != null;
      final paymentIsSelected = selectedPayment != null;
      final paymentData = paymentController.paymentData.value;
      final paymentDetail = paymentData
          ?.firstWhereOrNull((item) => item.name == selectedPayment?.name);
      final discount = voucherIsSelected ? selectedVoucher['value'] : 0;
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
                  'Kelas :',
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
                  padding: EdgeInsets.symmetric(vertical: 10),
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

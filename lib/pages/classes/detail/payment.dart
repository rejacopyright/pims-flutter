import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/_widgets/payment/payment_data.dart';

class BookingClassPaymentCard extends StatelessWidget {
  const BookingClassPaymentCard({super.key});

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
                      ClassFinalPrice(),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        clipBehavior: Clip.antiAlias,
                        color: primaryColor
                            .withOpacity(paymentIsSelected ? 1 : 0.5),
                        child: InkWell(
                          splashFactory: InkSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (paymentIsSelected) {
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                Get.rootDelegate.popRoute();
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

class ClassFinalPrice extends StatelessWidget {
  const ClassFinalPrice({
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
                  'Biaya Kelas :',
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

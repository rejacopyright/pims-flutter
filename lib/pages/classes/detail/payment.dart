// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/pages/classes/detail/main.dart';

class BookingClassPaymentController extends GetxController {
  RxBool submitButtonIsLoading = false.obs;
  setSubmitButtonIsLoading(e) => submitButtonIsLoading.value = e;
}

class BookingClassPaymentCard extends StatelessWidget {
  const BookingClassPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    final state = Get.put(BookingClassPaymentController());
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
                  color: Colors.black.withOpacity(0.15),
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
                        color: Colors.black.withOpacity(0.05),
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
                        color: primaryColor
                            .withOpacity(paymentIsSelected ? 1 : 0.5),
                        child: InkWell(
                          // to: '/order/detail',
                          // params: {
                          //   'status': 'unpaid',
                          //   'provider': (selectedPayment?.name).toString(),
                          //   'origin': 'confirm',
                          // },
                          onTap: () async {
                            if (!submitButtonIsLoading && paymentIsSelected) {
                              state.setSubmitButtonIsLoading(true);
                              await classTransaction();
                              state.setSubmitButtonIsLoading(false);
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
    final classDetailController = Get.put(ClassDetailController());
    return Obx(() {
      final detailClass = classDetailController.detailClass.value;
      final isMember = detailClass?['isMember'];
      final member_class = detailClass?['member_class'];
      final product_fee =
          isMember ? (member_class?['fee'] ?? 0) : (detailClass?['fee'] ?? 0);
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
                  'Biaya Kelas :',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 20),
                Text(
                  'Rp. ${currency.format(product_fee)}',
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
                    'Rp. ${currency.format((product_fee - discount) + (fee ?? 0))}',
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

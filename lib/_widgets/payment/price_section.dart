// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/config_controller.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    final configController = Get.put(ConfigController());
    return Obx(() {
      final selectedVoucher = paymentController.selectedVoucher.value;
      final voucherIsSelected = selectedVoucher != null;
      final visit_fee = configController.visit_fee.value;
      final voucher_fee = selectedVoucher?['value'] ?? 0;
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
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  currency.format(
                      voucherIsSelected ? visit_fee - voucher_fee : visit_fee),
                  style: TextStyle(
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

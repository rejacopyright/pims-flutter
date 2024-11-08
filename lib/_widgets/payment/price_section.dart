import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    return Obx(() {
      final selectedVoucher = paymentController.selectedVoucher.value;
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

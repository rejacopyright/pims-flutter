// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/voucher_card.dart';

class VoucherSection extends StatelessWidget {
  const VoucherSection({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    final voucherController = Get.put(VoucherCardController());
    return Obx(() {
      final selectedVoucher = paymentController.selectedVoucher.value;
      final voucherIsSelected = selectedVoucher != null;
      final voucher = selectedVoucher?['value'] ?? 0;
      final voucher_total = voucherController.count.value;
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
                            mainAxisSize: MainAxisSize.max,
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
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Tersedia ${currency.format(voucher_total)} Voucher',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: VoucherCard(),
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
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        offset: Offset(0, -5),
                                        blurRadius: 5,
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
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      Container(
                        child: voucherIsSelected
                            ? Text(
                                '-Rp. ${currency.format(voucher)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                            : Text(
                                'Gunakan Voucher',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
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

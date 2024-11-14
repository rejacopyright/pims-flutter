import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    final voucherData = List.generate(3, (index) => index.toString());
    return Obx(() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        children: voucherData.map((item) {
          final thisVoucherIsChecked =
              item == paymentController.selectedVoucher.value;
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              paymentController
                  .setSelectedVoucher(thisVoucherIsChecked ? null : item);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7.5),
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
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
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
                        padding: EdgeInsets.symmetric(horizontal: 15),
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
